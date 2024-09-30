package funkin.sound;

/**
 * FunkinSound callbacks
 */
typedef SoundCallbacks = {
    public var ?onStart:Void->Void;
    public var ?onComplete:Void->Void;
    public var ?onPause:Void->Void;
    public var ?onResume:Void->Void;
    public var ?onCreated:Void->Void;
    public var ?onFadeStart:Void->Void;
    public var ?onFadeEnd:Void->Void;
    public var ?onVolumeChange:Void->Void;
}

typedef SoundParams = {
    public var ?startTime:Float;
    public var ?autoPlay:Bool;
    public var ?autoDestroy:Bool;
    public var ?looped:Bool;
    public var ?loopAmount:Int;
    public var ?volume:Float;
}

/**
 * Sound manager used for the entire game, basically FlxSound with more features such as:
 * - Crossfading audio clips
 * - Partially loading audio via FlxPartialSound (mainly to save memory)
 * - Delaying audio using delayed time positions (based off original FunkinSound)
 */
class FunkinSound extends FlxBasic {
    private var sound:FlxSound;
    public var soundKey:String;

    public var isPlaying(get, default):Bool;

    function get_isPlaying() {
        return time >= 0 && sound.playing;
    }

    public var isOnDelayTime(get, default):Bool;

    function get_isOnDelayTime() {
        return sound != null && time < 0;
    }

    public var isCrossing(get, default):Bool;

    function get_isCrossing() {
        return sound.time == sound.length - crossTime && crossSound;
    }

    public var autoDestroy(get, set):Bool;

    function get_autoDestroy() {
        return sound.autoDestroy;
    }

    function set_autoDestroy(a:Bool) {
        return sound.autoDestroy = a;
    }

    public var volume(get, set):Float;

    function get_volume() {
        return sound != null ? sound.volume : 0;
    }

    function set_volume(v:Float) {
        return sound.volume = v;
    }

    private var _time:Float;
    public var time(get, set):Float;

    function get_time() {
        return _time;
    }

    function set_time(t:Float) {
        if (t < 0) {
            return sound.time = _time = t + Math.abs(t);
        } else {
            return sound.time = _time = t;
        }
    }

    public var length(get, never):Float;

    function get_length() {
        return sound.length;
    }

    public var isDelayed:Bool;
    public var autoPlay:Bool;
    public var looped:Bool;
    public var loopAmount:Int;
    public var crossTime:Float;
    public var crossSound:Bool;
    public var hasCrossed:Bool;

    // callbacks
    public var callbacks:SoundCallbacks;

    public function new() {
        super();
        sound = new FlxSound();
    }

    public function play() {
        if (_time < 0) 
            isDelayed = true;
        else
            sound.play();
    }

    override public function update(elapsed:Float) {
        var elapsedMs:Float = elapsed * 1000;
        if (isDelayed) {
            _time += elapsedMs;
            if (_time >= 0) {
                play();
                isDelayed = false;
            }
        } else {
            sound.update(elapsed);
        }
    }

    public function load(key:String, ?params:SoundParams) {
        this.soundKey = key;

        this._time = params.startTime;
        this.looped = params.looped;
        this.loopAmount = params.loopAmount;
        this.autoPlay = params.autoPlay;
        this.autoDestroy = params.autoDestroy;
        this.volume = params.volume;

        sound.loadEmbedded(soundKey, looped, autoDestroy);
    }
}