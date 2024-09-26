package funkin.backend.music;

import flixel.util.FlxSignal;

typedef BPMChangeEvent = {
    ?bpm:Float,
    ?songTime:Float,
    ?stepTime:Float
}

/**
 * The music backend for the game.
 */
class Conductor extends FlxBasic {
    private var _initialized:Bool = false;
    // variables
    public var bpm:Float = 100;
    public var forceBPM:Bool = false;
    
    public var offset:Float = 0;
    public var songPosition:Float = 0;

    public var curSong:FlxSound = new FlxSound();
    public var autoPlay:Bool = false;

    public var curStep:Int = 0;
    public var curBeat:Int = 0;
    public var curMeasure:Int = 0;
    
    public var bpmMap:Array<BPMChangeEvent> = [];

    // 4/4 time signature by default
    public var beatsPerMeasure:Int = 4;
    public var stepsPerBeat:Int = 4;

    // crochets
    public var crochet:Float = (60 / bpm) * 1000;
    public var stepCrochet:Float = crochet / stepsPerBeat;
    public var measureCrochet:Float = crochet * beatsPerMeasure;

    // safezones
    public var safeFrames:Int = 10;
    public var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    // signals
    public var onStepHit:FlxSignal = new FlxSignal();
    public var onBeatHit:FlxSignal = new FlxSignal();
    public var onMeasureHit:FlxSignal = new FlxSignal();
    public var onBPMChange:FlxSignal = new FlxSignal();
    public var onSongStart:FlxSignal = new FlxSignal();
    public var onSongEnd:FlxSignal = new FlxSignal();

    // static instance
    public static var instance(get, set):Conductor;
    private static var _instance:Conductor;

    // getters n setters
    static function get_instance() {
        if (_instance != null) {
            return _instance;
        } else { 
            try (set_instance(new Conductor()))
            catch (e) {
                trace('Conductor unable to be initialized!');
                return null;
            }
            return _instance;
        }
    }

    static function set_instance(newConductor:Conductor) {
        return _instance = newConductor;
    }

    public function new(?song:FlxSound, ?autoPlay:Bool, ?bpm:Float = 100, ?timeSignature:Array<Int> = [4, 4]) {
        super();
        
        this.curSong = song;
        this.autoPlay = autoPlay;
        this.bpm = bpm;
        this.beatsPerMeasure = timeSignature[0];
        this.stepsPerBeat = timeSignature[1];

        if (autoPlay) {
            if (song != null) {
                song.play();
            }
        }

        if (curSong != null) {
            if (curSong.playing) {
                songPosition = curSong.time;
            }
        } else {
            if (FlxG.sound.music.playing) {
                songPosition = FlxG.sound.music.time;
            }
        }

        onStepHit.removeAll();
        onBeatHit.removeAll();
        onMeasureHit.removeAll();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        var oldStep:Int = curStep;

        updateStep();
        updateBeat();
        updateMeasure();

        if (oldStep < curStep && curStep >= 0)
            stepHit();
    }
    
    private function updateMeasure() {
        curMeasure = Math.floor(curBeat / beatsPerMeasure);
    }

    private function updateBeat() {
        curBeat = Math.floor(curStep / stepsPerBeat);
    }

    private function updateStep() {
        var bpmChange:BPMChangeEvent = {};

        for (i in 0...bpmMap.length) {
            if (songPosition == bpmMap[i].songTime)
                bpmChange = bpmMap[i];
        }

        curStep = bpmChange.stepTime + Math.floor((songPosition - bpmChange.songTime) / stepCrochet);
    }

    public function stepHit() {
        if (curStep % stepsPerBeat == 0)
            beatHit();
        onStepHit.dispatch();
    }

    public function beatHit() {
        if (curStep % beatsPerMeasure == 0)
            measureHit();
        onBeatHit.dispatch();
    }
    
    public function measureHit() {
        onMeasureHit.dispatch();
    }

    // songs dont actually   exist yet
    // just keeping this here for future use
    public function mapBPMChanges(song:Void) {
        bpmMap = [];
    }

    public function resetCrochet(bpm:Float) {
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / stepsPerBeat;
        measureCrochet = crochet * beatsPerMeasure;
    }

    public function changeBPM(newBPM:Float) {
        bpm = newBPM;
        resetCrochet();
    }
}