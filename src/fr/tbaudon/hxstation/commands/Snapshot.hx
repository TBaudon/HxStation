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
	var mUsedLib : Array<String>;
	
	override public function run() {
		if(mArgs.length > 0){
			mPath = mArgs[0];
			mUsedLib = new Array<String>();
			if (FileSystem.exists(mPath)) {
				
				// get used libs
				var extension = Path.extension(mPath);
				switch(extension) {
					case 'xml' : 
						getLibsFromXML(mPath);
					case 'hxml' :
						getLibsFromHXML(mPath);
				}
			}else
				throw new CommandError(mPath + " : no such file");
		}
		else
			throw new CommandError("not enough arguments");
	}
	
	function getLibsFromHXML(mPath:String) 
	{
	}
	
	function getLibsFromXML(mPath:String) 
	{
		var fileContent = File.getContent(mPath);
		var xml = Xml.parse(fileContent);
		for (elem in xml.firstElement().elements()) {
			if (elem.nodeName == 'haxelib'){
				var lib = elem.get('name');
				var version = elem.get('version');
				if (version != null)
					lib += ":" + version;
				else
					lib += ":xxx";
				mUsedLib.push(lib);
				trace(lib);
			}
		}
	}
	
	
}