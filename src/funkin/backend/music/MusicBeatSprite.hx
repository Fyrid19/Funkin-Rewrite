package src.funkin.backend.music;

import funkin.backend.interfaces.IMusicBeat;

/**
 * FlxSprite with Music Beat properties.
 */
class MusicBeatSprite extends FlxSprite implements IMusicBeat {
    public var curStep:Int = 0;
    public var curBeat:Int = 0;
    public var curMeasure:Int = 0;

    public function new() {
        Conductor.onStepHit.add(stepHit);
        Conductor.onBeatHit.add(beatHit);
        Conductor.onMeasureHit.add(measureHit);
        FlxG.signals.preUpdate.add(update);
    }

    private function update(elapsed:Float) {
        curStep = Conductor.curStep;
        curBeat = Conductor.curBeat;
        curMeasure = Conductor.curMeasure;
    }
    
    public function stepHit() {}
    public function beatHit() {}
    public function measureHit() {}
}