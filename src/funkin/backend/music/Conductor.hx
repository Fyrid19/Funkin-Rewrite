package funkin.backend.music;

import flixel.util.FlxSignal;

typedef BPMChangeEvent = {
    ?bpm:Float,
    ?songTime:Float,
    ?stepTime:Float
}

/**
 * the entire backend of the game, VERY important
 */
@:nullSafety()
class Conductor {
    private var _initialized:Bool = false;
    // variables
    public var bpm(get, set):Float = 100;
    public var forceBPM:Bool = false;
    
    public var offset:Float = 0;
    public var songPosition:Float = 0;

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

    // private vars
    private var _bpm:Float = 100;

    // static instance
    public static var instance(get, set):Conductor;
    private static var _instance:Conductor;

    // getters n setters
    function get_bpm() {
        return _bpm;
    }

    function set_bpm(newBpm:Float) {
        resetCrochet(newBpm);
        return _bpm = newBpm;
    }

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

    // initialize the conductor
    public function new() {
        instance = new Conductor();
        _initialized = true;
    }

    public function update(elapsed:Float) {
        
    }

    public function stepHit() {
        if (curStep % stepsPerBeat == 0)
            beatHit();
        onStepHit.dispatch();
    }

    public function beatHit() {

    }
    
    public function measureHit() {
        
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
        bpm = _bpm;
    }
}