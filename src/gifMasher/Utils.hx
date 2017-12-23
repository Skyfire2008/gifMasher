package gifMasher;

import haxe.io.Bytes;

import format.png.Data;

import format.gif.Data.ColorTable;

/**
 * ...
 * @author skyfire2008
 */
class Utils{

	public static function makePNG(bytes: Bytes, width: Int, height: Int): Data{
		var l = new List();
		l.add(CHeader({ width : width, height : height, colbits : 8, color : ColTrue(true), interlaced : false }));
		
		var data = Bytes.alloc(width * height * 4 + height);
		for (y in 0...height){
			data.set((y * width) << 2, 0);
			data.blit(((y * width) << 2) + 1, bytes, (y * width) << 2, width << 2);
		}
		
		l.add(CData(format.tools.Deflate.run(data, 9)));
		l.add(CEnd);
		return l;
	}

	public static inline function swapColors(ct: ColorTable, a: Int, b: Int){
		for(i in 0...3){
			var temp=ct.get(a+i);
			ct.set(a+i, ct.get(b+i));
			ct.set(b+i, temp);
		}
	}

	public static inline function permuteArray<T>(array: Array<T>): Void{
		for(i in 0...array.length){
			var pos=i+Std.random(array.length-i);
			var temp: T=array[pos];
			array[pos]=array[i];
			array[i]=temp;
		}
	}
	
}