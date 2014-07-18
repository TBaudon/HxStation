package fr.tbaudon.hxstation;
import fr.tbaudon.hxstation.commands.Snapshot;

/**

 * MIT
 * https://github.com/TBaudon/HxStation
 */
class Main
{
    static public function main()
    {	
		var station = new HxStation();
		station.addCommand("snap", Snapshot);
		station.run();
	}
}