package at.dotpoint.display.renderable;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.display.rendering.RenderLayer;

//
interface IRenderable extends IComponent
{
    public var depth(get,set):Int;
    public var enabled(get,set):Bool;

    public function invalidate():Void;
    public function render( layer:RenderLayer ):Void;
    public function clear( layer:RenderLayer ):Void;
}

//
class RenderableSignal
{
    public static var DEPTH_CHANGED(default,never) = new SignalType("Renderable.DEPTH");
}

//
class RenderableType
{
    public static var CANVAS(default,never) = new ComponentType("Renderable.CANVAS");
}
