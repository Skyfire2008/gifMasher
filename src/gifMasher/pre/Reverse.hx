package gifMasher.pre;

import format.gif.Data;

import gifMasher.PreProcess;

class Reverse implements PreProcess{

	public function new(){

	}

	public function apply(data: Data): Data{
		var newBlocks: List<Block>=new List<Block>();

		var iter=data.blocks.iterator();

		var b: Block;
		while(iter.hasNext()){
			b=iter.next();

			switch(b){

				case BExtension(ext):

					switch(ext){
						case EGraphicControl(gce):

							var gceBlock=b;
							var frameBlock: Block=iter.next();

							while(!frameBlock.match(BFrame(_))){
								frameBlock=iter.next();
							}

							newBlocks.push(gceBlock);
							newBlocks.push(frameBlock);

						default: 
							newBlocks.push(b);
					}

				case BFrame(f):

					newBlocks.push(b);

				default:

					//skip BEOF
			}
		}

		newBlocks.add(BEOF);

		data.blocks=newBlocks;

		return data;
	}
}