package game.backend.input;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class Input {

    public static var LEFT:InputAction = new InputAction([FlxKey.LEFT, FlxKey.A], [FlxGamepadInputID.DPAD_LEFT, FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT]);
    public static var RIGHT:InputAction = new InputAction([FlxKey.RIGHT, FlxKey.D], [FlxGamepadInputID.DPAD_RIGHT, FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT]);
    public static var UP:InputAction = new InputAction([FlxKey.UP, FlxKey.W], [FlxGamepadInputID.DPAD_UP, FlxGamepadInputID.LEFT_STICK_DIGITAL_UP]);
    public static var DOWN:InputAction = new InputAction([FlxKey.DOWN, FlxKey.S], [FlxGamepadInputID.DPAD_DOWN, FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN]);
    public static var JUMP:InputAction = new InputAction([FlxKey.SPACE, FlxKey.Z], [FlxGamepadInputID.A]);
    public static var SHOOT:InputAction = new InputAction([FlxKey.X], [FlxGamepadInputID.X, FlxGamepadInputID.RIGHT_TRIGGER]);
    public static var PAUSE:InputAction = new InputAction([FlxKey.ESCAPE], [FlxGamepadInputID.START]);

    public static function bindByName(name:String, keys:Array<FlxKey>, ?buttons:Array<FlxGamepadInputID>):Void {
        var action:InputAction = switch(name) {
            case "LEFT": LEFT;
            case "RIGHT": RIGHT;
            case "UP": UP;
            case "DOWN": DOWN;
            case "JUMP": JUMP;
            case "SHOOT": SHOOT;
            case "PAUSE": PAUSE;
            default: null;
        };

        if (action != null) {
            if (keys != null) action.setKeys(keys);
            if (buttons != null) action.setButtons(buttons);
        }
    }

}

class InputAction {
    public var keys:Array<FlxKey>;
    public var buttons:Array<FlxGamepadInputID>;

    public var justPressed(get, never):Bool;
    public var justReleased(get, never):Bool;   
    public var pressed(get, never):Bool;

    public function new(?keys:Array<FlxKey>, ?buttons:Array<FlxGamepadInputID>) {
        this.keys = keys != null ? keys : [];
        this.buttons = buttons != null ? buttons : [];
    }

    public function setKeys(keys:Array<FlxKey>):Void {
        this.keys = keys;
    }

    public function setButtons(buttons:Array<FlxGamepadInputID>):Void {
        this.buttons = buttons;
    }

    public function get_pressed():Bool {
        if (keys.length > 0 && FlxG.keys.anyPressed(keys)) return true;
        
        var gamepad = FlxG.gamepads.lastActive;
        if (gamepad != null && buttons.length > 0 && gamepad.anyPressed(buttons)) return true;

        return false;
    }

    public function get_justPressed():Bool {
        if (keys.length > 0 && FlxG.keys.anyJustPressed(keys)) return true;
        
        var gamepad = FlxG.gamepads.lastActive;
        if (gamepad != null && buttons.length > 0 && gamepad.anyJustPressed(buttons)) return true;

        return false;
    }

    public function get_justReleased():Bool {
        if (keys.length > 0 && FlxG.keys.anyJustReleased(keys)) return true;
        
        var gamepad = FlxG.gamepads.lastActive;
        if (gamepad != null && buttons.length > 0 && gamepad.anyJustReleased(buttons)) return true;

        return false;
    }
}