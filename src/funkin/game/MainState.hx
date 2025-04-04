package funkin.game;

import funkin.game.song.SongGroup;

class MainState extends MusicBeatState {
    public var song:SongGroup;

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

    public function playSong(songName:String) {
        FlxG.sound.playMusic(Paths.inst(songName), 0.7);
        song = new SongGroup(songName);
    }
}