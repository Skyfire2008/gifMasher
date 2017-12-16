package gifMasher;

import haxe.io.Bytes;

import format.png.Data;

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
	
}