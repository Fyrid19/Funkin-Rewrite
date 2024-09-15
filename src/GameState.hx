package;

class GameState extends flixel.FlxState {
	override public function create() { 
		super.create();

		final text = new flixel.text.FlxText(0, 0, 1000, 'Hello World!', 30);
		text.active = false;
		text.alignment = 'center';
		text.screenCenter();
		add(text);
	}
}