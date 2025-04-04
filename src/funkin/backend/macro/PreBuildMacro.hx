package src.funkin.backend.macro; // throws it round in a circle

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class PreBuildMacro {
    public static var buildTime:Float = Sys.time();
    public static var buildDate:Date = Date.now();
    static function main() {
        trace('Compiling Build...');
        saveBuildTime();
    }

    static function saveBuildTime() {
        File.saveContent('.build_time', Std.string(buildTime));
    }
}