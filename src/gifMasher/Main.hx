package gifMasher;

import haxe.io.Output;
import haxe.io.Input;
import haxe.io.Bytes;

import neko.Lib;

import sys.io.File;

import gifMasher.ArgumentHandler;

import format.gif.Reader;
import format.gif.Tools;
import format.gif.Data;

using Lambda;

/**
 * @author skyfire2008
 */
class Main {
	
	static var stderr = Sys.stderr();
	
	static var path: String;
	
	static var gifData: Data;
	
	static var frames: Array<Bytes>;
	
	static function main(){
		var handler = new ArgumentHandler();
		handler.addArgOption("i".code, "input", function(arg: String){
			path = arg;
		});
		
		try{
			handler.processArguments(Sys.args());
		}catch(e: Dynamic){
			stderr.writeString(cast(e, String)+"\n");
			Sys.exit(1);
		}
		
		
		
		//decode the gif
		trace("Starting to parse the gif...");
		var start = Date.now();
		var reader = new Reader(File.read(path));
		gifData = reader.read();
		var end = Date.now();
		trace('Gif parsed in ${(end.getTime()-start.getTime())/1000} seconds');
		
		//allocate byte arrays
		frames = new Array<Bytes>();
		for (i in 0...Tools.framesCount(gifData)){
			frames.push(Bytes.alloc(gifData.logicalScreenDescriptor.width * gifData.logicalScreenDescriptor.height * 4));
		}
		
		//render the frames
		trace("Starting to render the gif...");
		var start = Date.now();
		GifRenderer.render(gifData, frames, 0, 1);
		var end = Date.now();
		trace('Gif rendered in ${(end.getTime()-start.getTime())/1000} seconds');
		
		var writer = new format.png.Writer(File.write("TestFrame.png"));
		writer.write(format.png.Tools.build32BGRA(gifData.logicalScreenDescriptor.width, gifData.logicalScreenDescriptor.height, Tools.extractFullBGRA(gifData, 5)));
		
		trace("Drawing frames");
		for (i in 0...frames.length){
			var writer = new format.png.Writer(File.write('frame$i.png'));
			writer.write(format.png.Tools.build32BGRA(gifData.logicalScreenDescriptor.width, gifData.logicalScreenDescriptor.height, frames[i]));
			//writer.write(Utils.makePNG(frames[i], gifData.logicalScreenDescriptor.width, gifData.logicalScreenDescriptor.height));
		}
		
		Sys.exit(0);
		
	}
	
	
	
}