package funkin.game;

class MainState extends MusicBeatState {
    override public function create() {
        super.create();

        final text = new flixel.text.FlxText(0, 0, 1000, 'Hello World!', 30);
		text.active = false;
		text.alignment = 'center';
		text.screenCenter();
		add(text);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }

    override public function beatHit() {
        trace('beat hit');
    }
}