package funkin.backend.music;

/**
 * Interface that has functions related to the BPM.
 */
interface IMusicBeat {
    public var curStep:Int;
    public var curBeat:Int;
    public var curMeasure:Int;
    public function stepHit():Void;
    public function beatHit():Void;
    public function measureHit():Void;
}