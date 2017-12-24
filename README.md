# GifMasher
A command line tool for glitching animated gif images.

## Building
To build run "__haxe gifMasher2.hxml__".
You'll need the format library, which can be installed by using "__haxelib install format__".

## Running
The basic command is "__gifMasher.exe -i/--input *\<path to input gif\>*__", however, its output is the same as its input. You can however, apply certain effects, using the following arguments:
* __--revColorTable__ - reverses every color table. __Color tables__ are essentially palletes and are used to conserve memory. They can be global(for the entire gif file) or local(for a single frame) and can also be sorted by the amount of occurences of colors.
* __--shuffleColorTable__ - randomly shuffles every color table.
* __--reverse__ - reverses the frame, together with their corresponding GCEs. __Frames__ are rectangles, which contain new pixel information, and don't necessarily have the same dimensions as the gif file. __GCE__s stands for "graphic control extensions", which is a block, that modifies the way the next frame is rendered.
* __--swapWH__ - swaps width and height of every frame.
* __-o/--output *\<output path\>*__ - defines the output path, which by default is the same as input path, but with "-output.gif" appended to it,
* __--stretch *\<stretch direction\>*__ - changes the dimension of every frame. Valid direction values are __LEFT__, __UP__, __DOWN__, __RIGHT__, __X__ and __Y__. Depending on the direction, width or height are stretched, but total area remains largely unchanged.