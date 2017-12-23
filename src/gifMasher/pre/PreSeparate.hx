package gifMasher.pre;

import format.gif.Data;

import gifMasher.PreProcess;

using Lambda;

/**
 * @brief 				Pre process, that has separate methods to process frames and GCEs
 */
class PreSeparate implements PreProcess{

	public function new(){
	}

	public function apply(data: Data): Data{
		data=procGlobal(data);

		var newBlocks: List<Block>=new List<Block>();

		for(b in data.blocks){
			
			switch(b){
				
				case BFrame(f):
					var newF=procFrame(f);
					if(newF != null){
						newBlocks.add(BFrame(f));
					}

				case BExtension(ext):
					
					switch(ext){

						case EGraphicControl(gce):
							var newGCE=procGCE(gce);
							if(newGCE != null){
								newBlocks.add(BExtension(EGraphicControl(newGCE)));
							}

						default:
							newBlocks.add(BExtension(ext));
					}

				default:
					newBlocks.add(b);
			}
		}

		data.blocks=newBlocks;
		return data;
	}

	/**
	 * @brief					Method to process a frame
	 * 
	 * @param f 				Frame
	 * @return 					New frame
	 */
	public function procFrame(f: Frame): Frame{
		return f;
	}

	/**
	 * @brief					Method to process a graphic control extension
	 * 
	 * @param g 				Graphic Control Extension
	 * @return 					New frame
	 */
	public function procGCE(g: GraphicControlExtension): GraphicControlExtension{
		return g;
	}

	public function procGlobal(data: Data): Data{
		return data;
	}

}