package funkin.backend;

import src.funkin.backend.macro.CommitMacro;

typedef BuildMetaData = {
    ?buildNum:Int,
    ?commitNum:Int,
    ?commitHash:String
}

class Globals {
    public static var ENGINE_VERSION(get, never):String;

    static function get_ENGINE_VERSION():String
        return '$ENGINE_VER_SUFFIX';

    public static var ENGINE_VER_SUFFIX:String = "Prototype"; // heh. thats funny
    
    public static var WINDOW_TITLE:String = "Friday Night Funkin' - " + ENGINE_VERSION;

    public static final COMMIT_NUMBER:Int = CommitMacro.curCommit;

    public static final COMMIT_HASH:String = CommitMacro.curCommitHash;

    public static final SAVE_PATH:String = "FyriDev";

    public static final CAMERA_LERP:Float = 0.04;

    public static final GAME_FONT:String = "vcr.ttf";

    public static final DEFAULT_SOUND_EXT:String = #if web "mp3" #else "ogg" #end;

    public static final DEFAULT_VIDEO_EXT:String = "mp4";
}