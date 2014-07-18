package fr.tbaudon.hxstation;
import fr.tbaudon.hxstation.commands.Setup;
import fr.tbaudon.hxstation.commands.Snapshot;
import haxe.io.Path;
import sys.FileSystem;

/**
 * MIT
 * https://github.com/TBaudon/HxStation
 */
class Main
{
    static public function main()
    {	
		var args = Sys.args();
		var nbArgs = args.length;
		
		// Set the working directory to the right path
		var currentCwd : String = Path.directory(Sys.getCwd());
		currentCwd = Path.removeTrailingSlashes(currentCwd);
		var lastSlacheA : Int = currentCwd.lastIndexOf('/')+1;
		var lastSlacheB : Int = currentCwd.lastIndexOf('\\')+1;
		if (lastSlacheA != -1 && lastSlacheA > lastSlacheB)
			currentCwd = currentCwd.substr(lastSlacheA, currentCwd.length - lastSlacheA);
		else if (lastSlacheB != -1)
			currentCwd = currentCwd.substr(lastSlacheB, currentCwd.length - lastSlacheB);
			
		if (nbArgs > 0 && currentCwd == 'HxStation' && FileSystem.isDirectory(args[args.length - 1])) 
			Sys.setCwd(args.pop());
		
		var station = new HxStation();
		station.addCommand("regLib", Snapshot);
		station.addCommand("setup", Setup);
		station.run();
	}
}