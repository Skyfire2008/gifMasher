package gifMasher.pre;

import format.gif.Data;

/**
 * @brief 					Stretches new pixels of frames
 * 
 */
class Stretch extends PreSeparate{

	private var dir: Direction;
	private var gifWidth: Int;
	private var gifHeight: Int;

	public function new(dir: Direction){
		this.dir=dir;
		super();
	}

	public override function procGlobal(data: Data): Data{
		gifWidth=data.logicalScreenDescriptor.width;
		gifHeight=data.logicalScreenDescriptor.height;
		return data;
	}

	public override function procFrame(f: Frame): Frame{

		if(dir==RIGHT){
			f.width=gifWidth-f.x;
			f.height=Std.int(f.pixels.length/f.width);
		}else if(dir==LEFT){
			f.width=f.x+f.width;
			f.height=Std.int(f.pixels.length/f.width);
			f.x=0;
		}else if(dir==UP){
			f.height=f.y+f.height;
			f.width=Std.int(f.pixels.length/f.height);
			f.y=0;
		}else if(dir==DOWN){
			f.height=gifHeight-f.y;
			f.width=Std.int(f.pixels.length/f.height);
		}else if(dir==X){
			f.x=0;
			f.width=gifWidth;
			f.height=Std.int(f.pixels.length/f.width);
		}else if(dir==Y){
			f.y=0;
			f.height=gifHeight;
			f.width=Std.int(f.pixels.length/f.height);
		}

		return f;

	}

}

enum Direction{
	RIGHT;
	LEFT;
	UP;
	DOWN;
	X;
	Y;
}