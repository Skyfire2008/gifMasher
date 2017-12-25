package gifMasher.graphics;

/**
 * RGB color
 * @author skyfire2008
 */
class Color{
	
	public var r: Int;
	public var g: Int;
	public var b: Int;

	public function new(r: Int=0, g: Int=0, b: Int=0){
		this.r = r;
		this.g = g;
		this.b = b;
	}
	
	public function toString(): String{
		return '(r: $r, g: $g, b: $b)';
	}
	
	public function toHSL(): HSL{
		var R: Float=this.r/255.0;
		var G: Float=this.g/255.0;
		var B: Float=this.b/255.0;

		var maxC=Math.max(Math.max(R, G), B);
		var minC=Math.min(Math.min(R, G), B);

		var L: Float=0.5*(minC+maxC); //calculate lightness

		var S: Float=0;
		var H: Float=0;

		if(maxC!=minC){
			if(L<0.5){ //calculate saturation
				S=(maxC-minC)/(maxC+minC);
			}else{
				S=(maxC-minC)/(2-(maxC+minC));
			}

			if(R==maxC){ //calculate hue
				H=(G-B)/(maxC-minC);
			}else if(G==maxC){
				H=2+(B-R)/(maxC-minC);
			}else{
				H=4+(R-G)/(maxC-minC);
			}

			H*=60;
			if(H>360){
				H-=360;
			}else if(H<0){
				H+=360;
			}
		}

		return new HSL(H, S, L);
	}
	
}

class HSL{
	public var h: Float;
	public var s: Float;
	public var l: Float;
	
	public function new(h: Float, s: Float, l: Float){
		this.h = h;
		this.s = s;
		this.l = l;
	}
	
	public function toString(): String{
		return '(h: $h, s: $s, l: $l)';
	}
	
	public function toColor(): Color{
		var R: Float;
		var G: Float;
		var B: Float;

		var h=this.h/360;
		var s=this.s;
		var l=this.l;

		if(s == 0){// achromatic
			R = l;
			G = l;
			B = l;
		}else{
			function hue2rgb(p: Float, q: Float, t: Float): Float{
				if(t < 0) t += 1;
				if(t > 1) t -= 1;
				if(t < 1/6) return p + (q - p) * 6 * t;
				if(t < 1/2) return q;
				if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
				return p;
			}

			var q: Float = l < 0.5 ? l * (1 + s) : l + s - l * s;
			var p: Float = 2 * l - q;
			R = hue2rgb(p, q, h + 1/3);
			G = hue2rgb(p, q, h);
			B = hue2rgb(p, q, h - 1/3);
		}

		return new Color(Std.int(255*R), Std.int(255*G), Std.int(255*B));
	}
}