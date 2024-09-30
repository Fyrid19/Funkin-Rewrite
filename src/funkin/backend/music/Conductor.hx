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
    // private var _initialized:Bool = false;

    // variables
    public static var bpm:Float = 100;
    public static var forceBPM:Bool = false;
    
    public static var offset:Float = 0;
    public static var songPosition:Float = 0;

    public static var targetSong:FunkinSound;
    public static var autoPlay:Bool = false;

    public static var curStep:Int = 0;
    public static var curBeat:Int = 0;
    public static var curMeasure:Int = 0;
    
    public static var bpmMap:Array<BPMChangeEvent> = [];

    // 4/4 time signature by default
    public static var beatsPerMeasure:Int = 4;
    public static var stepsPerBeat:Int = 4;

    // crochets
    public static var crochet:Float = (60 / bpm) * 1000;
    public static var stepCrochet:Float = crochet / stepsPerBeat;
    public static var measureCrochet:Float = crochet * beatsPerMeasure;

    // safezones
    public static var safeFrames:Int = 10;
    public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    // signals
    public static var whenStepHit:FlxSignal = new FlxSignal();
    public static var whenBeatHit:FlxSignal = new FlxSignal();
    public static var whenMeasureHit:FlxSignal = new FlxSignal();
    public static var whenBPMChange:FlxSignal = new FlxSignal();

    // unused (for now)
    public static var whenSongStart:FlxSignal = new FlxSignal();
    public static var whenSongEnd:FlxSignal = new FlxSignal();

    // callbacks
    public static var onStepHit:Void->Void;
    public static var onBeatHit:Void->Void;
    public static var onMeasureHit:Void->Void;
    public static var onBPMChange:Void->Void;

    // unused (for now)
    public static var onSongStart:Void->Void;
    public static var onSongEnd:Void->Void;

    // static instance
    private static var _instance:Conductor;

    public static var instance(get, set):Conductor;

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

    public function new(?song:FunkinSound, ?bpm:Float = 100, ?timeSignature:Array<Int> = [4, 4]) {
        super();
        
        this.targetSong = song != null ? song : null;
        this.bpm = bpm;
        this.beatsPerMeasure = timeSignature[0];
        this.stepsPerBeat = timeSignature[1];

        whenStepHit.removeAll();
        whenBeatHit.removeAll();
        whenMeasureHit.removeAll();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        var oldStep:Int = curStep;

        updateStep();
        updateBeat();
        updateMeasure();

        if (oldStep < curStep && curStep >= 0)
            stepHit();

        if (targetSong != null)
            songPosition = targetSong.time;
        else
            songPosition = FlxG.sound.music != null ? FlxG.sound.music.time : 0;
    }
    
    private static function updateMeasure() {
        curMeasure = Math.floor(curBeat / beatsPerMeasure);
    }

    private static function updateBeat() {
        curBeat = Math.floor(curStep / stepsPerBeat);
    }

    private static function updateStep() {
        var bpmChange:BPMChangeEvent = {};

        for (i in 0...bpmMap.length) {
            if (songPosition == bpmMap[i].songTime)
                bpmChange = bpmMap[i];
        }

        curStep = bpmChange.stepTime + Math.floor((songPosition - bpmChange.songTime) / stepCrochet);
    }

    // is this the best way to do it? prolly not, is this how im gonna do it? fuck yeah i am we ball
    public static function stepHit() {
        if (curStep % stepsPerBeat == 0)
            beatHit();
        whenStepHit.dispatch();
        onStepHit();
    }

    public static function beatHit() {
        if (curStep % beatsPerMeasure == 0)
            measureHit();
        whenBeatHit.dispatch();
        onBeatHit();
    }
    
    public static function measureHit() {
        whenMeasureHit.dispatch();
        onMeasureHit();
    }

    // songs dont actually   exist yet
    // just keeping this here for future use
    public static function mapBPMChanges(song:Void) {
        bpmMap = [];
    }

    public static function resetCrochet(bpm:Float) {
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / stepsPerBeat;
        measureCrochet = crochet * beatsPerMeasure;
    }

    public static function changeBPM(newBPM:Float) {
        bpm = newBPM;
        whenBPMChange.dispatch();
        onBPMChange();
        resetCrochet();
    }
}