package funkin.backend.assets;

#if sys
import sys.io.File;
#end

/**
 * Asset manager
 */
class FunkinAssets {
    public static function getToml(path:String) {
        var parser = new haxetoml.TomlParser;
        var file = File.getContent(path);
        return parser.parse(file);
    }
}