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
		l.add(CData(format.tools.Deflate.run(bytes, 9)));
		l.add(CEnd);
		return l;
	}
	
}