package at.dotpoint.display.renderable;

import at.dotpoint.display.renderable.IDisplayEntity.IDisplayObject;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.display.rendering.RenderLayer;

//
interface IRenderable extends IComponent<IDisplayObject>
{
    public var depth(get,set):Int;
    public var enabled(get,set):Bool;

    public function invalidate():Void;
    public function render( layer:RenderLayer ):Void;
    public function clear( layer:RenderLayer ):Void;
}
