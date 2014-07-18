package fr.tbaudon.hxstation.commands;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

/**
 * ...
 * @author Thomas B
 */
class RegLib extends Command
{
	
	var mPath : String;
	var mUsedLib : Array<String>;
	var mHaxelibPath : String;
	
	override public function run() {
		
		// get haxelib install path
		var proc = new Process("haxelib", ['config']);
		mHaxelibPath = proc.stdout.readAll().toString();
		mHaxelibPath = StringTools.replace(mHaxelibPath, '\\', '/');
		mHaxelibPath = mHaxelibPath.substr(0, mHaxelibPath.length - 2);
		
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
				
				// check used libs dependencies
				checkDependencies();
			}else
				throw new CommandError(mPath + " : no such file");
		}
		else
			throw new CommandError("not enough arguments");
	}
	
	function checkDependencies() 
	{
		var libToCheck = mUsedLib.copy();
		var checkedLib = new Array<String>();
		
		while (libToCheck.length > 0) {
			var currentLib = libToCheck.pop();
			checkedLib.push(currentLib);
			var libName = currentLib.split(':')[0];
			var libVersion = currentLib.split(':')[1];
			
			var libPath = getLibPath(libName, libVersion);
			trace(libPath);
		}
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
			}
		}
	}
	
	function getLibPath(name : String, version : String) : String{
		var currentFilePath = mHaxelibPath + name + "/.current";
		var currentVersion = File.getContent(currentFilePath);
		if (currentVersion == 'dev' && version == 'xxx') {
			var devPath =  mHaxelibPath + "/" + name + "/.dev";
			var path = File.getContent(devPath);
			path = StringTools.replace(path, '\\', '/');
			return path;
		}else if (version == 'xxx') {
			version = currentVersion;
			version = StringTools.replace(version, '.', ',');
			var libPath = mHaxelibPath + name + "/" + version;
			return libPath;
		}
		return null;
	}
}