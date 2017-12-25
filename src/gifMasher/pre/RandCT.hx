package gifMasher.pre;

import format.gif.Data;

/**
 * Randomizes the color table
 * @author skyfire2008
 */
class RandCT extends PreSeparate{
	
	private var mult: Int;

	public function new(mult: Int){
		super();
		this.mult = mult;
	}
	
	public override function procGlobal(data: Data): Data{
		if(data.logicalScreenDescriptor.hasGlobalColorTable){
			randCT(data.globalColorTable, data.logicalScreenDescriptor.globalColorTableSize);
		}
		return data;
	}

	public override function procFrame(f: Frame): Frame{
		if(f.localColorTable){
			randCT(f.colorTable, f.localColorTableSize);
		}
		return f;
	}
	
	private inline function randCT(ct: ColorTable, length: Int){
		for (i in 0...length * 3){
			
			var color = ct.get(i);
			color = color - (mult >> 1) + Std.random(mult);
			if (color < 0){
				color = 0;
			}else if (color > 255){
				color = 255;
			}
			ct.set(i, color);
			
		}
	}
	
}