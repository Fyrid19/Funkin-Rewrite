package src.proto.macro; // throws it round in a circle

import haxe.Json;

// #if sys
import sys.io.File;
import sys.FileSystem;
// #end

typedef BuildMetaData = {
    ?buildNum:Int,
    ?commitNum:Int,
    ?commitHash:String
}

class PostBuildMacro {
    public static var preBuildTime:Float = Std.parseFloat(File.getContent('.build_time'));
    public static var postBuildTime:Float = Sys.time();
    public static var postBuildDate:Date = Date.now();
    static function main() {
        var totalBuildTime:Float = 0;
        totalBuildTime = postBuildTime - preBuildTime;
        var totalBuildTimeFormatted:String = formatTime(totalBuildTime);

        Sys.println('- Finished compiling build! -');
        Sys.println('Pre-Build Date: ' + PreBuildMacro.buildDate);
        Sys.println('Post-Build Date: ' + postBuildDate);
        Sys.println('Total time: ' + totalBuildTimeFormatted);

        FileSystem.deleteFile('.build_time');

        updateBuildMeta();
    }

    static function formatTime(value:Float) {
        var time:Float = Math.round(value * 100) / 100;
        var minutes:Float = 0;
        var seconds:Float = 0;

        while (time > 60) {
            time -= 60;
            minutes++;
        }

        seconds = time;
        var secondsZero:String = seconds < 9 ? '0' + seconds : Std.string(seconds);
        return minutes > 0 ? minutes + ':' + secondsZero : Std.string(seconds);
    }

    public static var buildNumber:Int = 0;
    static function updateBuildMeta() {
        var metaPath:String = "buildmeta.json";
        var commitNumber:Int = CommitMacro.curCommit;
        var commitHash:String = CommitMacro.curCommitHash;
        var buildMetaData:BuildMetaData = {};
        
        if (FileSystem.exists(metaPath)) {
            try (buildMetaData = Json.parse(File.getContent(metaPath)))
            catch (e) {
                trace('Failed to load json: $e');
            }

            buildNumber = buildMetaData.buildNum + 1;
        }

        var data = {
            "buildNum": buildNumber,
            "commitNum": commitNumber,
            "commitHash": commitHash
        };

        var dataStr:String = Json.stringify(data);

        try (File.saveContent(metaPath, dataStr))
        catch (e) {
            trace('Build meta data (`$metaPath`) cannot be written to');
        }
    }
}