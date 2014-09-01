package fr.tbaudon.hxstation.commands;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import haxe.Json;
import sys.io.Process;
import neko.Lib;

/**
 * ...
 * @author Thomas B
 */
class Library
{

	public var name : String;
	public var version : String;
	public var dev : Bool;
	public var path : String;
	
	public var gitCommit : String;
	public var gitRemotes : Array<{name : String, path:String}>;
	
	static var mHaxelibPath : String;
	
	public static function getHaxelibPath() : String {
		if (mHaxelibPath == null) {
			// get haxelib install path
			var proc = new Process("haxelib", ['config']);
		
			mHaxelibPath = proc.stdout.readAll().toString();
			mHaxelibPath = StringTools.replace(mHaxelibPath, '\\', '/');
			mHaxelibPath = mHaxelibPath.substr(0, mHaxelibPath.length - 2);
		}
		
		return mHaxelibPath;
	}
	
	public function new(name : String = "") {
		dev = false;
		
		this.name = name;
		
		var currentFilePath = getHaxelibPath() + name + "/.current";
		var currentVersion = File.getContent(currentFilePath);
		if (FileSystem.exists(mHaxelibPath + name + "/.dev")) currentVersion = "dev";
		dev = currentVersion == "dev";
		
		if (dev) {
			var devPath =  mHaxelibPath + "/" + name + "/.dev";
			var path = File.getContent(devPath);
			path = StringTools.replace(path, '\\', '/');
			this.path = path;
			version = currentVersion;
		}else{
			var ver = currentVersion;
			ver = StringTools.replace(ver, '.', ',');
			var libPath = mHaxelibPath + name + "/" + ver;
			path = libPath;
			version = ver;
		}
	}
	
}