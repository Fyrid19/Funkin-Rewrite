package funkin.backend;

import flixel.util.FlxSave;

/**
 * This is where all the game's data is stored.
 * 
 * Recommended you pull from the FlxSave, but pulling from the data should work just as well.
 */
class FunkinData {
    public static var initialized:Bool = false;

    public static var save:FlxSave; // probably not the best way of going about this but eh
    public static var data:Map<String, Dynamic> = null;
    public static var dataDefault:Map<String, Dynamic> = [
        // Gameplay
        'downScroll' => false,
        'ghostTapping' => false,
        'flashingLights' => true,
        'cameraZoom' => true,

        // Graphics
        'shadersEnabled' => true,
        'globalAntialiasing' => true,
        'maxFramerate' => 60,

        // Hit Windows & Offsets
        'songOffset' => 0,
        'hitWindows' => [],

        // Misc
        'unfocusPause' => true,
        'childFriendly' => false,
        'discordRPC' => true,
        'sustainAlpha' => 0.6,
        'showFramerate' => true,
        'showMemory' => true,
        'showWatermark' => true,
    ];

    public static function initialize() {
        save = new FlxSave();
        save.bind('prototype', Globals.SAVE_PATH);
        data = dataDefault;

        loadKeybinds();
        loadData();

        if (data != null)
            initialized = true;
    }

    public static function loadKeybinds() {
        var csave = new FlxSave();
        csave.bind('controls', Globals.SAVE_PATH);
        
        if (csave.data.keybinds == null) {
            csave.data.keybinds = Controls.keyBinds;
            trace('No keybinds found, setting to default');
        } else {
            Controls.keyBinds = csave.data.keybinds;
        }

        if (csave.data.padbinds == null) {
            csave.data.padbinds = Controls.controllerBinds;
            trace('No controller binds found, setting to default');
        } else {
            Controls.controllerBinds = csave.data.padbinds;
        }
    }

    public static function loadData() {
        var newData:Bool = false;
        for (key => value in data) {
            if (Reflect.getProperty(save.data, key) == null) {
                Reflect.setProperty(save.data, key, value);
                newData = true;
            } else {
                data[key] = Reflect.getProperty(save.data, key);
            }

            // trace('Map: ' + key + ', ' + value);
            // trace('Data: ' + key + ', ' + Reflect.getProperty(save.data, key));
        }
        
        #if debug
        if (!newData)
            trace('Loaded data successfully!');
        else
            trace('No data was found, your data has been reset');
        #end
    }

    public static function saveData(?log:Bool) {
        for (key => value in data) {
            Reflect.setProperty(save.data, key, value);
        }
        if (log) trace('Data saved!');
    }

    public static function setToDefault(?log:Bool) {
        for (key => value in dataDefault) {
            Reflect.setProperty(save.data, key, value);
        }
        data = dataDefault;
        if (log) trace('Data reset');
    }
}