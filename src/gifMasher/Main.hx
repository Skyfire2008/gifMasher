package gifMasher;

import haxe.io.Output;
import haxe.io.Input;
import haxe.io.Bytes;

import haxe.io.Path;

import neko.Lib;

import neko.vm.Thread;
import neko.vm.Lock;

import sys.io.File;

import format.gif.Reader;
import format.gif.Tools;
import format.gif.Data;
import format.gif.Writer;

import gifMasher.ArgumentHandler;

import gifMasher.pre.*;
import gifMasher.pre.Stretch.Direction;

using Lambda;
using haxe.EnumTools;

/**
 * @author skyfire2008
 */
class Main {
	
	static var stderr = Sys.stderr();
	
	static var inPath: String;
	static var outPath: String=null;
	
	static var tt: Int = 1;
	
	static var gifData: Data;
	
	static var frames: Array<Bytes>;

	static var preProcesses: Array<PreProcess> = new Array<PreProcess>();
	
	static function usage(){
		var stdout = Sys.stdout();
		stdout.writeString('USAGE: ${Path.withoutDirectory(Sys.executablePath())} -i <path to input gif>\n');
		stdout.writeString("OPTIONAL ARGUMENTS:\n");
		stdout.writeString("	-o/--output <path to output> - specifies the output path, which by default is the same as input path, but with '-output.gif' appended to it\n");
		stdout.writeString("	--reverse - reverses the frame order\n");
		stdout.writeString("	--stretch <direction> - changes the dimensions new pixels of every frame by given direction, valid direction values are UP, DOWN, RIGHT, LEFT, X, Y\n");
		stdout.writeString("	--revColorTable - reverses every color table\n");
		stdout.writeString("	--shuffleColorTable - randomly shuffles every color table\n");
		stdout.writeString("	--swapWH - swaps width and height of every frame\n");
		stdout.writeString("	-h/--help - prints out this message\n");
	}
	
	static function main(){

		//define command line arguments
		var handler = new ArgumentHandler();
		handler.addNoArgOption("h".code, "help", function(){
			usage();
		});
		handler.addArgOption("i".code, "input", function(arg: String){
			inPath = arg;
		});
		handler.addArgOption("t".code, "threads", function(arg: String){
			tt = Std.parseInt(arg);
		});
		handler.addArgOption("o".code, "output", function(arg: String){
			outPath=arg;
		});
		handler.addArgOption( -1, "stretch", function(arg: String){
			try{
				preProcesses.push(new Stretch(Direction.createByName(arg)));
			}catch (e: Dynamic){
				throw '$arg is not a valid direction';
			}
		});
		handler.addNoArgOption(-1, "revColorTable", function(){
			preProcesses.push(new RevCT());
		});
		handler.addNoArgOption(-1, "reverse", function(){
			preProcesses.push(new Reverse());
		});
		handler.addNoArgOption(-1, "shuffleColorTable", function(){
			preProcesses.push(new ShufCT());
		});
		handler.addNoArgOption(-1, "swapWH", function(){
			preProcesses.push(new SwapWH());
		});
		
		try{
			handler.processArguments(Sys.args());
		}catch(e: Dynamic){
			stderr.writeString("\n"+cast(e, String) + "\n\n");
			usage();
			Sys.exit(1);
		}
		
		//decode the gif
		trace("Starting to parse the gif...");
		var start = Date.now();

		var reader = new Reader(File.read(inPath));
		gifData = reader.read();

		var end = Date.now();
		trace('Gif parsed in ${(end.getTime()-start.getTime())/1000} seconds');

		//preprocess the gif
		trace("Starting to pre-process the gif...");
		var start = Date.now();
		for(p in preProcesses){
			gifData=p.apply(gifData);
		}
		var end = Date.now();
		gifData.blocks.add(BExtension(EComment('Created via GifMasher on ${Date.now().toString()}')));
		trace('Gif pre-processed in ${(end.getTime()-start.getTime())/1000} seconds');

		//write the gif
		var writer=new Writer(File.write(outPath == null ? inPath.substring(0, inPath.length-4)+"-output.gif" : outPath));
		writer.write(gifData);
		
		//allocate byte arrays
		/*frames = new Array<Bytes>();
		for (i in 0...Tools.framesCount(gifData)){
			frames.push(Bytes.alloc(gifData.logicalScreenDescriptor.width * gifData.logicalScreenDescriptor.height * 4));
		}*/
		
		//render the frames
		/*trace("Starting to render the gif...");
		var start = Date.now();
		if (tt != 1){
			var lock = new Lock();
			for (i in 0...tt){
				Thread.create(GifRenderer.render.bind(gifData, frames, i, tt, lock));
			}
			for (i in 0...tt){
				lock.wait();
			}
		}else{
			GifRenderer.render(gifData, frames, 0, 1, null);
		}
		
		var end = Date.now();
		trace('Gif rendered in ${(end.getTime()-start.getTime())/1000} seconds');
		
		trace("Drawing frames");
		for (i in 0...frames.length){
			var writer = new format.png.Writer(File.write('frame$i.png'));
			writer.write(format.png.Tools.build32BGRA(gifData.logicalScreenDescriptor.width, gifData.logicalScreenDescriptor.height, frames[i]));
		}*/
		
		Sys.exit(0);
		
	}
}