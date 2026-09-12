import lime.system.System;

class Utils {
    public static var isDebugMode:Bool = 
        #if DEBUG_MODE true #else false #end;
}