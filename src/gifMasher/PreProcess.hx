package gifMasher;

import haxe.io.Bytes;

import format.gif.Data;

using Lambda;

/**
 * Contains methods to preprocess gif data
 * @author skyfire2008
 */
class PreProcess{
	
	public static function removeGces(data: Data){
		data.blocks = data.blocks.filter(function(b): Bool{
			var result = false;
			
			switch(b){
				case BExtension(ext):
					switch(ext){
						case EGraphicControl(egc):
							result = false;
						default:
							result = true;
					}
					
				default:
					result = true;
			}
			
			return result;
		});
	}

	public static function shuffleTr(data: Data){
		var globalCtSize = data.logicalScreenDescriptor.hasGlobalColorTable ? data.logicalScreenDescriptor.globalColorTableSize : 0;
		var gce: GraphicControlExtension = null;
		
		data.blocks.iter(function(b){
			switch(b){
				case BFrame(f):
					
					if (gce != null && gce.hasTransparentColor){
						gce.transparentIndex = f.localColorTable ? Std.random(f.localColorTableSize) : Std.random(globalCtSize);
					}
					gce = null;
					
				case BExtension(ext):
					
					switch(ext){
						case EGraphicControl(e):
							gce = e;
						default:
					}
					
				default:
			}
		});
	}
	
	public static function stretch(data: Data, dist: Int){
		
		var width = data.logicalScreenDescriptor.width;
		var height = data.logicalScreenDescriptor.height;
		var bgInd = data.logicalScreenDescriptor.backgroundColorIndex;
		
		var trInd = bgInd;
		
		data.blocks.iter(function(b){
			switch(b){
				case BFrame(f):
					
					var newWidth = 0;
					if (f.width + dist < width - f.x){
						newWidth = f.width + dist;
					}else{
						newWidth = width - f.x;
					}
					
					var newHeight = Math.ceil(f.width * f.height / newWidth);
					var rest = newWidth * newHeight - f.width * f.height;
					var newPixels = Bytes.alloc(newWidth * newHeight);
					newPixels.blit(0, f.pixels, 0, f.width * f.height);
					newPixels.fill(f.width * f.height, rest, trInd);
					
					f.width = newWidth;
					f.height = newHeight;
					f.pixels = newPixels;
					
				case BExtension(ext):
					switch(ext){
						case EGraphicControl(gce):
							if (gce.hasTransparentColor){
								trInd = gce.transparentIndex;
							}
						default:
					}
				default:
			}
			
			trInd = bgInd;
		});
		
	}
	
	/**
	 * Reverses the color tables
	 * @param	data					gif data
	 */
	public static function revColorTables(data: Data){
		if (data.logicalScreenDescriptor.hasGlobalColorTable){
			revCt(data.globalColorTable, data.logicalScreenDescriptor.globalColorTableSize);
		}
		
		data.blocks.iter(function(b){
			switch(b){
				case BFrame(f):
					if (f.localColorTable){
						revCt(f.colorTable, f.localColorTableSize);
					}
				default:
					//skip
			}
		});
	}
	
	/**
	 * Reverses a given color table
	 * @param	ct					color table
	 * @param	length				color table length
	 */
	private static inline function revCt(ct: ColorTable, length: Int){
		
		var cur = 0; //current
		var opp = (length-1)*3; //opposite
		
		for (i in 0...(length >> 1)){
			
			for (j in 0...3){
				var temp = ct.get(opp + j);
				ct.set(opp + j, ct.get(cur + j));
				ct.set(cur + j, temp);
			}
			
			cur += 3;
			opp -= 3;
		}
	}
	
}