package at.dotpoint.display.renderable;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.display.renderable.IRenderable.RenderableType;
import at.dotpoint.display.rendering.RenderLayer;

/**
 *
 */
class NullRenderable extends DisplayComponent implements IRenderable
{

    //
    public var depth(get,set):Int;
    public var enabled(get,set):Bool;

    //
    public function new( ?type:ComponentType )
    {
        if( type == null )
            type = RenderableType.CANVAS;

        super( type );
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private function get_enabled( ):Bool return false;
    private function set_enabled( value:Bool ):Bool
    {
        return false;
    }

    //
    private function get_depth( ):Int return -1;
    private function set_depth( value:Int ):Int
    {
        return -1;
    }

    //
    public function invalidate():Void
    {
        //; throw new UnsupportedMethodException();
    }

    //
    public function render( layer:RenderLayer ):Void
    {
        //; throw new UnsupportedMethodException();
    }

    //
    public function clear( layer:RenderLayer ):Void
    {
        //; throw new UnsupportedMethodException();
    }
}
