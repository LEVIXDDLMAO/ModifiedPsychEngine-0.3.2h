package;

import openfl.media.Sound;
import flixel.FlxG;
import haxe.Json;
import sys.io.File;
import openfl.utils.Assets;
import sys.FileSystem;
import lime.system.System;
import haxe.io.Path;

//made to access internal storage for platforms that support sys
class StorageAccess
{
    public static var checkDirs:Map<String, String> = new Map();
    //filename, filepath, filecontent
    public static var checkFiles:Map<String, Array<String>> = new Map();

    public static function checkStorage()
    {
        //hm? dunno if i should do it like this
        checkDirs.set("main", Path.join([System.userDirectory, 'sanicbtw_pe_files']));

        //checkDirs.set("weeks", Path.join([checkDirs.get("main"), 'weeks'])); dont know how i will get this to work tbh
        checkDirs.set("data", Path.join([checkDirs.get("main"), "data"]));
        checkDirs.set("songs", Path.join([checkDirs.get("main"), "songs"]));

        for (varName => dirPath in checkDirs) 
        {
            if(!FileSystem.exists(dirPath)){ FileSystem.createDirectory(dirPath); }
        }

        /*
        for(varName => args in checkFiles)
        {
            if(!FileSystem.exists(args[0])){ File.saveContent(args[0], args[1]); }
        }*/

        openfl.system.System.gc();
    }

    public static function getInst(song:String, ext = ".ogg")
    {
        var filePath = Path.join([checkDirs.get("songs"), song.toLowerCase(), 'Inst$ext']);
        trace(filePath);
        if(FileSystem.exists(filePath))
        {
            return Sound.fromFile(filePath);
        }
        else { trace("Couldnt find inst"); }
        return null;
    }

    public static function getVoices(song:String, ext = ".ogg")
    {
        var filePath = Path.join([checkDirs.get("songs"), song.toLowerCase(), 'Voices$ext']);
        trace(filePath);
        if(FileSystem.exists(filePath))
        {
            return Sound.fromFile(filePath);
        }
        else { trace("Couldnt find voices"); }
        return null;
    }

    public static function getChart(song:String, diff:Int = 1)
    {
        var diffString:String = "";
        switch (diff)
        {
            case 0:
                diffString = "-easy";
            case 1:
                diffString = "";
            case 2:
                diffString = "-hard";
        }
        var chartFile:String = song.toLowerCase() + diffString + ".json";
        var mainSongPath:String = Path.join([checkDirs.get("data"), song.toLowerCase()]);

        return Path.join([mainSongPath, chartFile]);
    }

    //heavily based off musictstate code lol
    public static function getSongs()
    {
        return FileSystem.readDirectory(StorageAccess.checkDirs.get('songs'));
    }

    public static function getCharts(song:String)
    {
        var mainSongPath:String = Path.join([checkDirs.get("data"), song.toLowerCase()]);

        if(FileSystem.exists(mainSongPath))
        {
            var possibleCharts = FileSystem.readDirectory(mainSongPath);
            trace("Possible charts: " + possibleCharts);
            return "exists";
        }
        else { trace("Song doesnt exists on the data folder"); }
        return null;
    }
}