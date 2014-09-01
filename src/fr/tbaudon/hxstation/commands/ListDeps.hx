package fr.tbaudon.hxstation.commands;
import haxe.io.Path;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import neko.Lib;

/**
 * ...
 * @author Thomas B
 */
class ListDeps extends Command
{
	
	var mPath : String;
	var mUsedLib : Array<Library>;
	var mHaxelibPath : String;
	
	override public function help() {
		Lib.println('List the dependencies of a haxe project and generate a dependencies file.');
		Lib.println('Use : hxstation listdeps <path to project file>');
	}
	
	override public function run() {		
		if(mArgs.length > 0){
			mPath = mArgs[0];
			mUsedLib = new Array<Library>();
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
		
		Sys.println('Dependencies : ');
		
		while (libToCheck.length > 0) {
			var currentLib = libToCheck.pop();
			checkedLib.push(currentLib.name);
			
			Sys.println(currentLib.name + " : " + currentLib.version + " " + currentLib.path);
			
			var json = Json.parse(File.getContent(currentLib.path + "/haxelib.json"));
			if (json.dependencies != null) {
				var libs : Dynamic = json.dependencies;
				for (field in Reflect.fields(libs)) {
					var lib = new Library(field);
					if (addToCheck(lib, libToCheck, checkedLib))
						libToCheck.push(lib);
				}
			}
		}
	}
	
	function addToCheck(lib : Library, libToCheck : Array<Library>, checkedLib : Array<String>) : Bool {
		for (a in libToCheck)
			if (a.name == lib.name) return false;
		for (b in checkedLib)
			if (b == lib.name) return false;
		return true;
	}
	
	function getLibsFromHXML(mPath:String) 
	{
	}
	
	function getLibsFromXML(mPath:String) 
	{
		var fileContent = File.getContent(mPath);
		var xml = Xml.parse(fileContent);
		for (elem in xml.firstElement().elements()) {
			if (elem.nodeName == 'haxelib') {
				var lib = new Library(elem.get('name'));
				mUsedLib.push(lib);
			}
		}
	}
}