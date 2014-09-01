package fr.tbaudon.hxstation.commands;
import sys.io.File;
import neko.Lib;

/**
 * ...
 * @author Thomas B
 */
class Setup extends Command
{

	override public function run() {
		var haxepath = Sys.getEnv("HAXEPATH");
		if (haxepath == null)
			throw new CommandError('HAXEPATH is not defined');
		else
			install(haxepath);
	}
	
	override public function help() {
		Lib.println("Install HxStation as a command line tool. Once the tool is set up, you can use hxstation by typing 'hxstation' instead of 'haxelib run haxstation' ...");
	}
	
	function install(haxepath : String) 
	{
		var script = "@echo off\nhaxelib run HxStation %*";
		var out = File.write(haxepath + '/HxStation.bat', false);
		out.writeString(script);
		out.close();
	}
	
}