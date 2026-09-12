package game.backend.input;

import Reflect;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
class Input{

	public static var LEFT:InputAction = new InputAction([FlxKey.LEFT, FlxKey.A]);
	public static var RIGHT:InputAction = new InputAction([FlxKey.RIGHT, FlxKey.D]);
	public static var UP:InputAction = new InputAction([FlxKey.UP, FlxKey.W]);
	public static var DOWN:InputAction = new InputAction([FlxKey.DOWN, FlxKey.S]);
	public static var JUMP:InputAction = new InputAction([FlxKey.SPACE, FlxKey.Z]);
	public static var SHOOT:InputAction = new InputAction([FlxKey.X]);
	public static var PAUSE:InputAction = new InputAction([FlxKey.ESCAPE]);

	public static function bindByName(name:String, keys:Array<Dynamic>):Void{
		switch(name){
			case "LEFT": LEFT.setKeys(keys);
			case "RIGHT": RIGHT.setKeys(keys);
			case "UP": UP.setKeys(keys);
			case "DOWN": DOWN.setKeys(keys);
			case "JUMP": JUMP.setKeys(keys);
			case "SHOOT": SHOOT.setKeys(keys);
			case "PAUSE": PAUSE.setKeys(keys);
			default: /* unknown */
		}
	}

}

class InputAction{
	public var keys:Array<Dynamic>;
	public var gamepadButtons:Array<Dynamic>;

	public var justPressed(get, never):Bool;
	public var justReleased(get, never):Bool;   
	public var pressed(get, never):Bool;

	public function new(keys:Array<Dynamic>){
		this.keys = keys;
		this.gamepadButtons = [];
	}

	public function setKeys(keys:Array<Dynamic>):Void{
		this.keys = keys;
	}

	public function addGamepadButton(btn:Dynamic):Void{
		this.gamepadButtons.push(btn);
	}

	public function setGamepadButtons(btns:Array<Dynamic>):Void{
		this.gamepadButtons = btns;
	}

	public function get_pressed():Bool{
		if (keys != null && keys.length > 0 && FlxG.keys.anyPressed(keys)) return true;
		// check gamepads dynamically to avoid type issues
		for (b in gamepadButtons){
			if (checkGamepadButton(b, 'pressed')) return true;
		}
		return false;
	}

	public function get_justPressed():Bool{
		if (keys != null && keys.length > 0 && FlxG.keys.anyJustPressed(keys)) return true;
		for (b in gamepadButtons){
			if (checkGamepadButton(b, 'justPressed')) return true;
		}
		return false;
	}

	public function get_justReleased():Bool{
		if (keys != null && keys.length > 0 && FlxG.keys.anyJustReleased(keys)) return true;
		for (b in gamepadButtons){
			if (checkGamepadButton(b, 'justReleased')) return true;
		}
		return false;
	}

	private function checkGamepadButton(btn:Dynamic, methodName:String):Bool{
		var gps = Reflect.field(FlxG, 'gamepads');
		if (gps == null) return false;
		// try up to 4 gamepads
		for (i in 0...4){
			var getFn = Reflect.field(gps, 'get');
			var pad = null;
			if (getFn != null) pad = Reflect.callMethod(gps, getFn, [i]);
			else pad = Reflect.field(gps, 'list') != null ? Reflect.getProperty(Reflect.field(gps, 'list'), i) : null;
			if (pad == null) continue;
			var fn = Reflect.field(pad, methodName);
			if (fn != null){
				var res = Reflect.callMethod(pad, fn, [btn]);
				if (res) return true;
			}
		}
		return false;
	}

}