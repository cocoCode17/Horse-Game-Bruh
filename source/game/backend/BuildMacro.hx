package game.backend;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
#end

class BuildMacro
{
    /**
     * Esta función se ejecuta ÚNICAMENTE durante la compilación.
     * Lee build.txt, le suma 1, guarda el archivo y devuelve el número como un Int.
     */
    public static macro function getBuildNumber():Expr
    {
        var filePath = "build.txt";
        var buildNum = 0;

        if (FileSystem.exists(filePath))
        {
            var content = File.getContent(filePath);
            buildNum = Std.parseInt(StringTools.trim(content));
            if (Math.isNaN(buildNum)) buildNum = 0;
        }

        buildNum++;

        File.saveContent(filePath, Std.string(buildNum));

        return Context.makeExpr(buildNum, Context.currentPos());
    }
}