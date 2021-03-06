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
	
	public var gitHead : String;
	public var gitRemotes : Array<{name : String, url:String}>;
	
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
		version = currentVersion;
		
		if (dev) {
			var devPath =  mHaxelibPath + "/" + name + "/.dev";
			var path = File.getContent(devPath);
			if (FileSystem.exists(path + '/.git'))
			{
				getGitHead();
				getGitRemotes();
			}
		}
	}
	
	public function getGitHead() {
		var path = getPath();
		var gitRef = File.getContent(path + '/.git/HEAD');
		gitRef = gitRef.substr(5); // remove first part before ref path
		gitRef = gitRef.substr(0, gitRef.length - 1); // remove \n
		var refPath = new Path(path + '/.git/' + gitRef);
		gitHead = File.getContent(refPath.toString());
		gitHead = gitHead.substr(0, gitHead.length - 1);
	}
	
	public function getGitRemotes() {
		gitRemotes = new Array<{name : String, url:String}>();
		
		var config = File.getContent(getPath() + '/.git/config');
		var lines = config.split('\n');
		while (lines.length > 0) {
			var line = lines.shift();
			var remoteName : String = "";
			if (line.indexOf('[remote "') == 0) {
				remoteName = line.substr(9, line.length - 11);
				
				while (line != null && line.indexOf('\turl = ') != 0)
					line = lines.shift();
				var url = line.substr(7);
				gitRemotes.push( { name : remoteName, url : url } );
			}
		}
	}
	
	public function getPath() {
		var path : String;
		if (dev) {
			var devPath =  mHaxelibPath + "/" + name + "/.dev";
			path = File.getContent(devPath);
		}else{
			var ver = version;
			ver = StringTools.replace(ver, '.', ',');
			path = mHaxelibPath + name + "/" + ver;
		}
		
		return path;
	}
	
}