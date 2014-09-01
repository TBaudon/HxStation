package fr.tbaudon.hxstation;

import fr.tbaudon.hxstation.commands.Command;
import fr.tbaudon.hxstation.commands.CommandError;

/**
 * ...
 * @author Thomas B
 */
class HxStation
{
	
	var mArgs : Array<String>;
	var mCommands : Map<String, Class<Command>>;
	
	static var mInstance : HxStation;
	
	public static function getInstance() {
		return mInstance;
	}

	public function new() 
	{
		mArgs = Sys.args();
		mCommands = new Map<String, Class<Command>>();
		mInstance = this;
	}
	
	public function addCommand(name : String, command:Class<Command>) {
		mCommands[name] = command;
	}
	
	public function getCommands() : Map<String, Class<Command>> {
		return mCommands;
	}
	
	public function run() {
		var commandName = mArgs.shift();
		var command : Command;
		if (commandName != null && mCommands[commandName] != null) {
			var commandClass = mCommands[commandName];
			command = Type.createInstance(commandClass, [mArgs]);
			try {
				command.run();
			}catch (e : CommandError) {
				Sys.println('Error : ' + e.message);
				Sys.println('\nHelp : ');
				command.help();
			}
		}
		else
			Sys.println('no such command');
	}
	
}