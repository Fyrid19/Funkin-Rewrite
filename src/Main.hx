package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.StageScaleMode;
import flixel.graphics.FlxGraphic;

#if windows
@:headerCode("
	#include <windows.h>
	#include <winuser.h>
")
#end

class Main extends Sprite {
	public function new() {
		super();

		addChild(new FlxGame(1280, 720, GameState, 120, true));
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		registerAsDPICompatible();
		setFlxDefines(); 
	}

	function setFlxDefines() {
		FlxG.cameras.useBufferLocking = true;
		FlxG.fixedTimestep = false;
	}

	@:functionCode('
        SetProcessDPIAware();
    ')
    public static function registerAsDPICompatible() {}

	// Get rid of hit test function because mouse memory ramp up during first move (-Bolo)
    @:noCompletion override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool return false;
    @:noCompletion override function __hitTestHitArea(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool return false;
    @:noCompletion override function __hitTestMask(x:Float, y:Float):Bool return false;
}
