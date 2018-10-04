package at.dotpoint.display.rendering;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.math.geometry.Rectangle;

//
interface IRenderViewport extends IComponent
{
    public var boundings(default, null):Rectangle;
}

//
class RenderViewportSignal
{
    public static var TICK(default,never):SignalType = new SignalType("Viewport.TICK" );
    public static var RESIZE(default,never):SignalType = new SignalType("Viewport.RESIZE");
}


//
class RenderViewportType
{
    public static var CANVAS(default,never):ComponentType = new ComponentType("RenderViewport.CANVAS");
}