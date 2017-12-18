package gifMasher;

import haxe.io.Bytes;
import sys.io.File;

import neko.vm.Lock;

import format.gif.Data;

using Lambda;

/**
 * ...
 * @author skyfire2008
 */
class GifRenderer{

	/**
	 * Renders the gif into the given byte array
	 * @param	data				decoded gif data
	 * @param	frames				array of frames, each as a byte array
	 * @param	tn					this thread number
	 * @param	tt					number of total threads
	 * @param 	lock				lock for synchronisation
	 */
	public static inline function render(data: Data, frames: Array<Bytes>, tn: Int, tt: Int, lock: Lock=null){
		
		var width = data.logicalScreenDescriptor.width;
		var height = data.logicalScreenDescriptor.height;
		
		var gce: GraphicControlExtension=null;
		
		var disposalMethod = DisposalMethod.NO_ACTION;
		var trIndex = -1;
		var bgIndex = data.logicalScreenDescriptor.backgroundColorIndex;
		
		var ct: ColorTable = data.globalColorTable; //TODO: add a method to "uncompress" color tables if color resolution!=7
		
		var fNum = 0; //current fram number
		var curBytes: Bytes; //current frame bytes
		
		var blocks = data.blocks;
		blocks.iter(function(block){
			switch(block){
				case BFrame(frame): //if block is a frame
					
					var disposalMethod = (gce!=null) ? gce.disposalMethod : DisposalMethod.NO_ACTION;
					var trIndex = (gce!=null && gce.hasTransparentColor) ? gce.transparentIndex : -1;
					
					//trace('${frame.width}, ${frame.height}, $disposalMethod');
					
					curBytes = frames[fNum];
					
					ct = frame.localColorTable ? frame.colorTable : data.globalColorTable;
					
					//RENDER THE BACKGROUND FIRST
					
					//create a background color line if disposal method is FILL_BACKGROUND
					var bgLine: Bytes = null;
					var bgColor: Int=0;
					if (disposalMethod == DisposalMethod.FILL_BACKGROUND){
						bgLine = Bytes.alloc(width << 2);
						bgColor = getColor(ct, bgIndex);
						bgColor += (bgIndex == trIndex) ? 0 : 0xff000000;
						
						for (i in 0...width){
							bgLine.setInt32(i<<2, bgColor);
						}
					}
					
					var y: Int = tn;
					while (y < height){
						
						if (y >= frame.y && y < frame.y + frame.height){ //if we have hit new pixels
							
							if(disposalMethod==FILL_BACKGROUND){
								curBytes.blit((y * width) << 2, bgLine, 0, frame.x << 2);
								curBytes.blit((frame.x + frame.width) << 2, bgLine, 0, (width - (frame.x + frame.width)) << 2);
							}else{ //TODO: special case for RENDER_PREVIOUS
								if(fNum>0){
									curBytes.blit((y * width) << 2, frames[fNum - 1], (y * width) << 2, frame.x << 2);
									curBytes.blit((y * width + frame.width + frame.x) << 2, frames[fNum - 1], (y * width + frame.width + frame.x) << 2, (width - (frame.x + frame.width)) << 2);
								}
							}
							
						}else{ //otherwise
							
							if(disposalMethod==FILL_BACKGROUND){
								curBytes.blit((y * width) << 2, bgLine, 0, bgLine.length);
							}else{ //TODO: special case for RENDER_PREVIOUS
								if (fNum > 0){
									curBytes.blit((y * width) << 2, frames[fNum - 1], (y * width) << 2, width << 2);
								}
							}
						}
						y += tt;
					}
					
					//NOW RENDER THE NEW PIXELS
					var y = (tn >= (frame.y % tt)) ? Math.floor(frame.y / tt) * tt + tn : Math.ceil(frame.y / tt) * tt + tn;
					
					var srcPos = (y-frame.y)*frame.width;
					while (y < frame.y + frame.height){
						
						var x = frame.x;
						while (x < frame.x + frame.width){
							
							//if (fNum == 5 && tn == 0){trace(srcPos); }
							var ind = frame.pixels.get(srcPos);
							var color: Int;
							
							if (ind == trIndex){
								if (disposalMethod == FILL_BACKGROUND){
									color = bgColor; 
								}else if (fNum > 0){
									color = frames[fNum - 1].getInt32((y*width + x) << 2);
								}else{
									color = 0;
								}
							}else{
								color = 0xff000000 | getColor(ct, ind); //TODO: make a method to retrieve colors from color table
							}
							
							curBytes.setInt32(((y * width + x) << 2), color);
							
							x++;
							srcPos++;
							
						}
						//if (fNum == 5 && tn == 0){trace("skip!");}
						srcPos += (tt-1)*frame.width; //different threads handle different src lines
						y += tt;
						
					}
					
					fNum++;
					gce = null;
					
				case BExtension(ext): //if block is an extension
					
					switch(ext){
						case EGraphicControl(g):
							gce = g;
						default:
							//skip all other extensions
					}
					
				case BEOF: //if block is an EOF
					return;
			}
		});
		
		if (lock != null){
			lock.release();
		}
		
	}
	
	public static inline function getColor(ct: ColorTable, ind: Int): Int{
		ind *= 3;
		return (ct.get(ind) << 16) | (ct.get(ind + 1) << 8) | ct.get(ind + 2);
	}
	
}