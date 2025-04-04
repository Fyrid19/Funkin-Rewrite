package funkin.game;

class InitState extends MusicBeatState {
    override function create() {
        super.create();

        Application.current.window.title = Globals.WINDOW_TITLE;
        FlxG.switchState(() -> new funkin.game.MainState());
    }
}