package fr.tbaudon.hxstation.commands;
import sys.io.File;

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
	
	function install(haxepath : String) 
	{
		var script = "@echo off\nhaxelib run HxStation %*";
		var out = File.write(haxepath + '/HxStation.bat', false);
		out.writeString(script);
		out.close();
	}
	
}