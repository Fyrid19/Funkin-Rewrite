package funkin.backend.music;

import flixel.FlxSubState;

/**
 * FlxSubState with Music Beat properties.
 */
class MusicBeatSubState extends FlxSubState implements IMusicBeat {
    public var curStep:Int = 0;
    public var curBeat:Int = 0;
    public var curMeasure:Int = 0;

    public function new() {
        super();
    }
    
    override function create() {
        super.create();
        
        Conductor.whenStepHit.add(stepHit);
        Conductor.whenBeatHit.add(beatHit);
        Conductor.whenMeasureHit.add(measureHit);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        curStep = Conductor.curStep;
        curBeat = Conductor.curBeat;
        curMeasure = Conductor.curMeasure;
    }

    public function stepHit() {}
    public function beatHit() {}
    public function measureHit() {}
}