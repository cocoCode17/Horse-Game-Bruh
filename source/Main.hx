package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.util.FlxColor;
import game.debug.FPSCounter;
import game.play.PlayState;
import openfl.display.FPS;
import openfl.display.Sprite;
typedef GameConfigs =
{
	var width:Int;
	var height:Int;
	var initialState:Class<FlxState>;
	var FPS:Int;
	var skipSplash:Bool;
	var startFullscreen:Bool;
}

class Main extends Sprite
{
	var gameConfig:GameConfigs;

	// public static var buildNum:Int = 0;

	function gameSetup()
	{
		gameConfig = {
			width: 0,
			height: 0,
			initialState: PlayState,
			FPS: 60,
			skipSplash: true,
			startFullscreen: false
		}
	}

	public function new()
	{
		super();
		gameSetup();
		var daGame = new FlxGame(gameConfig.width, gameConfig.height, gameConfig.initialState, gameConfig.FPS, gameConfig.FPS, gameConfig.skipSplash,
			gameConfig.startFullscreen);
		addChild(daGame);

		// if (GameDataManager.DEBUG_MODE){
		var fps = new FPSCounter(10, 10, FlxColor.WHITE);
		addChild(fps);
		// }

		#if windows
		game.backend.window.WindowsApi.enable();
		#end

		CustomTrace.init();
	}
}
