# GifMasher
A command line tool for glitching animated gif images.

## Building
To build run "__haxe gifMasher2.hxml__".
You'll need the format library, which can be installed by using "__haxelib install format__".

## Running
The basic command is "__gifMasher.exe -i/--input *\<path to input gif\>*__", however, its output is the same as its input. You can however, apply certain effects, using the following arguments:
* __--revColorTable__ - reverses every color table. __Color tables__ are essentially palletes and are used to conserve memory. They can be global(for the entire gif file) or local(for a single frame) and can also be sorted by the amount of occurences of colors.
* __--shuffleColorTable__ - randomly shuffles every color table.
* __--reverse__ - reverses the frame, together with their corresponding GCEs. __Frames__ are rectangles, which contain new pixel information, and don't necessarily have the same dimensions as the gif file. __GCEs__ stand for "graphic control extensions", which is a block, that modifies the way the next frame is rendered.
* __--swapWH__ - swaps width and height of every frame.
* __-o/--output *\<output path\>*__ - defines the output path, which by default is the same as input path, but with "-output.gif" appended to it.
* __--stretch *\<stretch direction\>*__ - changes the dimension of every frame. Valid direction values are __LEFT__, __UP__, __DOWN__, __RIGHT__, __X__ and __Y__. Depending on the direction, width or height are stretched, but total area remains largely unchanged.
* __--randColorTable *\<max random value\>*__ - randomizes every color table values. Randomization is performed channel-wise, new channel value is calculates as follows: *prev value - (max random value/2) + (value between 0 and max random value)*.
* __--addHue *\<additional hue value\>*__ - changes every frame color table. To do so, it converts every color to HSL representation, adds the provided value multiplied by the frame number to its hue, then converts it back to RGB and stores it in the color table. If the provided value is 0, it takes the default, which is 360/total number of frames.