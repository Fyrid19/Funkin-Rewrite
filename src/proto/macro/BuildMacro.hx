package src.proto.macro; // hrk

import haxe.Json;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

typedef BuildMetaData = {
    ?buildNum:Int,
    ?commitNum:Int,
    ?commitHash:String
}

class BuildMacro {
    public static var buildNumber:Int;
    static function main() {
        var metaPath:String = "buildmeta.json";
        var commitNumber:Int = CommitMacro.curCommit;
        var commitHash:String = CommitMacro.curCommitHash;
        var buildMetaData:BuildMetaData;
        
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