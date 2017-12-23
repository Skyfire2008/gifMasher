package gifMasher;

import haxe.io.Bytes;

import format.gif.Data;

using Lambda;

interface PreProcess{

	public function apply(data: Data): Data;
	
	/*public static function removeGces(data: Data){
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
		
	}*/
	
}