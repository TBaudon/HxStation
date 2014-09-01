package fr.tbaudon.hxstation.commands;
import fr.tbaudon.hxstation.HxStation;
import neko.Lib;
/**
 * ...
 * @author Thomas B
 */
class Help extends Command
{
	
	var mStation : HxStation;
	var mCommands : Map<String, Class<Command>>;
	
	override public function run() {
		mStation = HxStation.getInstance();
		mCommands = mStation.getCommands();
		Lib.println('Available commands : \n--------------------');
		for (command in mCommands) {
			if (command != Help) {
				var current = Type.createInstance(command, []);
				var nameAr = Type.getClassName(command).split('.');
				var name = nameAr[nameAr.length - 1].toLowerCase();
				Lib.println('\n\t$name : ');
				Lib.print('\t\t');
				current.help();
			}
		}
	}
	
}