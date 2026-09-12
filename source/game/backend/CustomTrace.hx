package game.backend;

import haxe.PosInfos;

enum LogLevel {
    DEBUG;
    TRACE;
    WARNING;
    ERROR;
}

class CustomTrace
{
    private static inline var RESET:String  = "\x1B[0m";
    private static inline var GRAY:String   = "\x1B[90m";
    private static inline var CYAN:String   = "\x1B[36m";
    private static inline var BLUE:String   = "\x1B[34m";
    private static inline var YELLOW:String = "\x1B[33m";
    private static inline var RED:String    = "\x1B[31m";
    private static inline var GREEN:String  = "\x1B[32m";

    public static function init():Void {
        haxe.Log.trace = function(v:Dynamic, ?infos:PosInfos) {
			var level:LogLevel = LogLevel.TRACE; 
            var message:Dynamic = v;

            if (infos != null && infos.customParams != null && infos.customParams.length > 0) {
                var lastParam = infos.customParams[infos.customParams.length - 1];

                if (Std.isOfType(lastParam, LogLevel)) {
					level = cast lastParam;
                    infos.customParams.pop();
                }

                if (infos.customParams.length > 0) {
                    message = [v].concat(infos.customParams).join(", ");
                }
            }

            output(message, level, infos);
        };
    }

	private static function output(v:Dynamic, level:LogLevel, ?infos:PosInfos):Void
	{
        var now = Date.now();
        var hours = StringTools.lpad(Std.string(now.getHours()), "0", 2);
        var minutes = StringTools.lpad(Std.string(now.getMinutes()), "0", 2);
        var seconds = StringTools.lpad(Std.string(now.getSeconds()), "0", 2);
        var timeStr = '$GRAY[$hours:$minutes:$seconds]$RESET';

        var levelStr:String = "";
        switch (level) {
            case DEBUG:   levelStr = '$CYAN[DEBUG]$RESET';
            case TRACE:   levelStr = '$BLUE[TRACE]$RESET';
            case WARNING: levelStr = '$YELLOW[WARN ]$RESET';
            case ERROR:   levelStr = '$RED[ERROR]$RESET';
        }

        var typeName = Type.getClassName(Type.getClass(v));
        if (typeName == null) typeName = Type.typeof(v).getName();
        var typeStr = '$GREEN<$typeName>$RESET';

        var posStr = "";
        if (infos != null) {
            posStr = '$GRAY(${infos.fileName}:${infos.lineNumber})$RESET';
        }

        Sys.println('$timeStr $levelStr $posStr $typeStr: $v');
    }
}