package fr.tbaudon.hxstation.commands;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Thomas B
 */
class Snapshot extends Command
{
	
	var mPath : String;
	
	override public function run() {
		if(mArgs.length > 0){
			mPath = mArgs[0];
			if (FileSystem.exists(mPath)){
				var extension = Path.extension(mPath);
				switch(extension) {
					case 'xml' : 
						parseLimeProj(mPath);
					case 'hxml' :
						parseHxProj(mPath);
				}
			}else
				throw new CommandError(mPath + " : no such file");
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