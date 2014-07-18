package fr.tbaudon.hxstation.commands;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Thomas B
 */
class Snapshot extends Command
{
	
	var mPath : String;

	public function new(args : Array<Dynamic>) 
	{
		super(args);
	}
	
	override public function run() {
		if(mArgs.length > 0){
			mPath = mArgs[0];
			if (FileSystem.exists(mPath)){
				var extension = mPath.split('.')[1];
				switch(extension) {
					case 'xml' : 
						parseLimeProj(mPath);
					case 'hxml' :
						parseHxProj(mPath);
				}
			}else
				throw new CommandError("No such file");
		}
		else
			throw new CommandError("not enough arguments");
	}
	
	function parseHxProj(mPath:String) 
	{
		
	}
	
	function parseLimeProj(mPath:String) 
	{
		var fileContent = File.getContent(mPath);
		trace(fileContent);
	}
	
	
}