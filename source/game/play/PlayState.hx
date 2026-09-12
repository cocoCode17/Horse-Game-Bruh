package game.play;

import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		trace("lol " + Utils.isDebugMode);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
