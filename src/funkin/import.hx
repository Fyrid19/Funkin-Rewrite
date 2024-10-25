package funkin;

#if !macro
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.sound.FlxSound;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import lime.app.Application;

import funkin.sound.FunkinSound;
import funkin.backend.music.Conductor;
import funkin.backend.music.MusicBeatState;
import funkin.backend.Controls;
import funkin.backend.FunkinData;
import funkin.backend.Globals;

using StringTools;
using Lambda;
#end