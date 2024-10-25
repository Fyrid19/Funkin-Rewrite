package funkin.backend;

typedef BuildMetaData = {
    ?buildNum:Int,
    ?commitNum:Int,
    ?commitHash:String
}

class Globals {
    public static final WINDOW_TITLE:String = "Friday Night Funkin': Prototype Engine";

    public static var ENGINE_VERSION(get, never):String;
    static function get_ENGINE_VERSION():String {
        return Application.current.meta.get("version") + ENGINE_VER_SUFFIX;
    }

    public static var ENGINE_VER_SUFFIX:String = " Prototype"; // heh. thats funny

    public static var BUILD_META(get, never):BuildMetaData;
    static function get_BUILD_META():BuildMetaData {
        return haxe.Json.parse('buildmeta.json');
    }

    public static final BUILD_NUMBER:Int = Globals.BUILD_META.buildNum;

    public static final COMMIT_NUMBER:Int = Globals.BUILD_META.commitNum;

    public static final COMMIT_HASH:String = Globals.BUILD_META.commitHash;

    public static final SAVE_PATH:String = "FyriDev";

    public static final CAMERA_LERP:Float = 0.04;
}