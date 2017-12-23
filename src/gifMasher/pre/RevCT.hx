package gifMasher.pre;

import format.gif.Data;

import gifMasher.Utils;

/**
 * @brief 					Reverses the color tables 
 */
class RevCT extends PreSeparate{

	public function new(){
		super();
	}

	public override function procGlobal(data: Data): Data{
		if(data.logicalScreenDescriptor.hasGlobalColorTable){
			revCT(data.globalColorTable, data.logicalScreenDescriptor.globalColorTableSize);
		}
		return data;
	}

	public override function procFrame(f: Frame): Frame{
		if(f.localColorTable){
			revCT(f.colorTable, f.localColorTableSize);
		}
		return f;
	}

	private function revCT(ct: ColorTable, length: Int){

		var cur = 0; //current
		var opp = (length-1)*3; //opposite
		
		for (i in 0...(length >> 1)){
			
			Utils.swapColors(ct, cur, opp);
			
			cur += 3;
			opp -= 3;
		}
	}
}