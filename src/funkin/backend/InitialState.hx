package funkin.backend;

import flixel.FlxState;

/**
 * State where data and several backends are initialized.
 */
class InitialState extends FlxState {
    public var nextState = new funkin.game.MainState();
    override public function create() {
        Application.current.window.title = Globals.WINDOW_TITLE;

        trace('- APP INFO -');
        trace('Current Title: ${Globals.WINDOW_TITLE}');
        trace('Engine Version: ${Globals.ENGINE_VERSION}');
        trace('Build Number: ${Globals.BUILD_NUMBER}');
        trace('Build Commit: ${Globals.COMMIT_NUMBER}');

        FunkinData.initialize();
        Conductor.init();

        FlxG.switchState(nextState);
    }
}