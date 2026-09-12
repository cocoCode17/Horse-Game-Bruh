package game.debug;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

@:font("contents/fonts/Spartacus.ttf")
class UndertaleFont extends Font {}

class FPSCounter extends Sprite 
{
    private var textField:TextField;
    private var textSize:Int = 22;
    private var times:Array<Float>;
    private var lastTime:Float;
    private var buildNum:Int = 0;

    // Sprites para los dos gráficos
    private var msGraphSprite:Sprite;
    private var memGraphSprite:Sprite;

    private var msHistory:Array<Float>;
    private var memHistory:Array<Float>;

    private final maxPoints:Int = 35;
    private final graphWidth:Float = 110;
    private final graphHeight:Float = 18;

    public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF) 
    {
        super();

        this.x = x;
        this.y = y;

        Font.registerFont(UndertaleFont);
        var font = new UndertaleFont();

        var format = new TextFormat(font.fontName, textSize, color);
        format.align = TextFormatAlign.LEFT;

        textField = new TextField();
        textField.defaultTextFormat = format;
        textField.embedFonts = true;
        textField.selectable = false;
        textField.multiline = true;
        textField.wordWrap = false;
        textField.width = 250;
        textField.height = 85;
        
        textField.sharpness = 400;
        addChild(textField);

        // Gráfico 1: MS (Líneas picos)
        msGraphSprite = new Sprite();
        msGraphSprite.x = 0;
        msGraphSprite.y = 88;
        addChild(msGraphSprite);

        // Gráfico 2: MEM (Área/Barras)
        memGraphSprite = new Sprite();
        memGraphSprite.x = 0;
        memGraphSprite.y = 112;
        addChild(memGraphSprite);

        msHistory = [];
        memHistory = [];
        times = [];
        lastTime = Lib.getTimer();

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        buildNum = game.backend.BuildMacro.getBuildNumber();
        trace(buildNum);
    }

    private function onEnterFrame(e:Event):Void 
    {
        var currentTime = Lib.getTimer();
        var deltaTime = currentTime - lastTime;
        lastTime = currentTime;

        times.push(currentTime);
        while (times[0] < currentTime - 1000) {
            times.shift();
        }

        var currentFPS = times.length;
        var memoryMB = System.totalMemory / (1024 * 1024);
        var frameTimeMS = deltaTime;

        textField.text = 'FPS: $currentFPS\n' +
                         'MS: ${Math.round(frameTimeMS * 10) / 10}ms\n' +
                         'MEM: ${Math.round(memoryMB * 100) / 100} MB\n' +
                         'BUILD NUM: ' + buildNum;

        // Actualizar historiales
        msHistory.push(frameTimeMS);
        if (msHistory.length > maxPoints) msHistory.shift();

        memHistory.push(memoryMB);
        if (memHistory.length > maxPoints) memHistory.shift();

        drawMSGraph();
        drawMemGraph();
    }

    // Gráfico de Picos (Línea)
    private function drawMSGraph():Void 
    {
        var g = msGraphSprite.graphics;
        g.clear();

        if (msHistory.length < 2) return;

        g.lineStyle(1.5, 0xFFFFFF, 0.9);
        var stepX = graphWidth / (maxPoints - 1);
        var maxMS:Float = 33.3;

        for (i in 0...msHistory.length) {
            var ratio = Math.min(msHistory[i] / maxMS, 1.0);
            var px = i * stepX;
            var py = graphHeight - (ratio * graphHeight);

            if (i == 0) g.moveTo(px, py);
            else g.lineTo(px, py);
        }
    }

    // Gráfico de Memoria (Área/Sombra Rellena)
    private function drawMemGraph():Void 
    {
        var g = memGraphSprite.graphics;
        g.clear();

        if (memHistory.length < 2) return;

        // Buscar max local para ajustar escala dinámica de memoria
        var maxMem:Float = 1.0;
        for (m in memHistory) if (m > maxMem) maxMem = m;

        var stepX = graphWidth / (maxPoints - 1);

        g.beginFill(0xFFFFFF, 0.4); // Relleno translúcido
        g.lineStyle(1, 0xFFFFFF, 1.0);
        
        g.moveTo(0, graphHeight);

        for (i in 0...memHistory.length) {
            var ratio = memHistory[i] / maxMem;
            var px = i * stepX;
            var py = graphHeight - (ratio * graphHeight);
            g.lineTo(px, py);
        }

        g.lineTo((memHistory.length - 1) * stepX, graphHeight);
        g.lineTo(0, graphHeight);
        g.endFill();
    }
}