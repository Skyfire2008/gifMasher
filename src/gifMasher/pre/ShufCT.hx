package gifMasher.pre;

import format.gif.Data;

import gifMasher.Utils;

/**
 * @brief 					Shuffles the color tables 
 */
class ShufCT extends PreSeparate{

	public static var accurate: Bool=true;

	public function new(){
		super();
	}

	public override function procGlobal(data: Data): Data{
		if(data.logicalScreenDescriptor.hasGlobalColorTable){
			shuffleCT(data.globalColorTable, data.logicalScreenDescriptor.globalColorTableSize);
		}
		return data;
	}

	public override function procFrame(f: Frame): Frame{
		if(f.localColorTable){
			shuffleCT(f.colorTable, f.localColorTableSize);
		}
		return f;
	}

	private function shuffleCT(ct: ColorTable, length: Int){
		var cur: Int=0;

		if(ShufCT.accurate){
			var i=(length-1)*3;
			var color: Int=0;
			var empty=-1;

			while(color==0){
				color=(ct.get(i) << 16) | (ct.get(i+1) << 8) | ct.get(i);
				i-=3;
				empty++;
			}

			length-=empty;
		}

		for(i in 0...length){
			var pos=i+Std.random(length-i);
			Utils.swapColors(ct, pos*3, cur);
			cur+=3;
		}
	}

}