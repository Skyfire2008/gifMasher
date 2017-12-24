package gifMasher.pre;

import format.gif.Data;

class SwapWH extends PreSeparate{

	public function new(){
		super();
	}

	public override function procFrame(f: Frame): Frame{
		var temp=f.height;
		f.height=f.width;
		f.width=temp;
		return f;
	}

}