package funkin.backend.music;

import flixel.util.FlxSignal;

typedef BPMChangeEvent = {
    ?bpm:Float;
    ?songTime:Float;
    ?stepTime:Float;
}

/**
 * the entire backend of the game, VERY important
 */
@:nullSafety()
class Conductor {
    // variables
    public static var bpm(get, set):Float = 100;
    public static var songPosition:Float = 0;
    public static var curStep:Int = 0;
    public static var curBeat:Int = 0;
    public static var curMeasure:Int = 0;
    public static var offset:Float = 0;
    public static var forceBPM:Bool = false;
    
    public static var bpmMap:Array<BPMChangeEvent> = [];

    // 4/4 time signature by default
    public static var beatsPerMeasure:Int = 4;
    public static var stepsPerBeat:Int = 4;

    // aiming to get rid of these some time soon
    public static var crochet:Float = (60 / bpm) * 1000;
    public static var stepCrochet:Float = crochet / stepsPerBeat;
    public static var measureCrochet:Float = crochet * beatsPerMeasure;

    // signals
    public static var onStepHit:FlxSignal = new FlxSignal();
    public static var onBeatHit:FlxSignal = new FlxSignal();
    public static var onMeasureHit:FlxSignal = new FlxSignal();
    public static var onBPMChange:FlxSignal = new FlxSignal();
    
    public static var onSongStart:FlxSignal = new FlxSignal();
    public static var onSongEnd:FlxSignal = new FlxSignal();

    // private vars
    private static var _bpm:Float = 100;

    // static instance
    public static var instance(get, set):Conductor;
    private static var _instance:Conductor;

    // getters n setters
    static function get_bpm() {
        return this.bpm = _bpm;
    }

    static function set_bpm(b:Float) {
        _bpm = b;
        resetCrochet(b);
        return bpm = b;
    }

    static function get_instance() {
        if (_instance != null) {
            return _instance;
        } else { 
            try (set_instance(new Conductor()))
            catch (e) {
                trace('Conductor unable to be initialized!');
            }
        }
    }

    static function set_instance(i:Conductor) {
        // gonna continue later im tired LOL!
    }

    // initialize the conductor
    public function new() {
        instance = new Conductor();
    }

    // songs dont actually   exist yet
    // just keeping this here for future use
    public static function mapBPMChanges(song:Void) {
        bpmMap = [];
    }

    public static function resetCrochet(?bpm:Float = this._bpm) {
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / stepsPerBeat;
        measureCrochet = crochet * beatsPerMeasure;
    }

    public static function changeBPM(newBPM:Float) {
        _bpm = newBPM;
        bpm = _bpm;
    }
}