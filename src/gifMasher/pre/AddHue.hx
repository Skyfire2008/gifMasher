package gifMasher.pre;

import haxe.io.Bytes;

import format.gif.Data;
import format.gif.Tools;

import gifMasher.graphics.Color;

/**
 * Adds hue to the color table
 * @author skyfire2008
 */
class AddHue extends PreSeparate{
	
	private var dh: Float;
	private var dhTotal: Float = 0;
	private var globalCT: ColorTable;
	private var globalLength: Int;
	
	public function new(dh: Float = 0){
		super();
		dh = dh % 360;
		dh = (dh < 0) ? dh + 360 : dh;
		this.dh=dh;
	}
	
	public override function procGlobal(data: Data): Data{
		if (dh == 0){
			dh = 360.0 / Tools.framesCount(data);
		}
		
		if(data.logicalScreenDescriptor.hasGlobalColorTable){
			globalCT = data.globalColorTable;
			globalLength = data.logicalScreenDescriptor.globalColorTableSize;
		}
		
		return data;
	}
	
	public override function procFrame(f: Frame): Frame{
		if (!f.localColorTable){
			f.localColorTable = true;
			f.localColorTableSize = globalLength;
			f.colorTable = Bytes.alloc(globalLength * 3);
			f.colorTable.blit(0, globalCT, 0, globalLength * 3);
		}
		
		var ind: Int = 0;
		for (i in 0...f.localColorTableSize){
			
			var c = new Color(f.colorTable.get(ind), f.colorTable.get(ind + 1), f.colorTable.get(ind + 2));
			
			var hsl = c.toHSL();
			hsl.h += dhTotal;
			if (hsl.h >= 360.0){
				hsl.h -= 360.0;
			}
			
			c = hsl.toColor();
			
			f.colorTable.set(ind, c.r);
			f.colorTable.set(ind+1, c.g);
			f.colorTable.set(ind+2, c.b);
			
			ind += 3;
			
		}
		
		dhTotal = (dhTotal + dh) % 360.0;
		return f;
	}
}