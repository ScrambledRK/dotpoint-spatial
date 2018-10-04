package at.dotpoint.display.renderable;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.display.renderable.IRenderable.RenderableSignal;
import at.dotpoint.display.renderable.IRenderable.RenderableType;
import at.dotpoint.display.rendering.RenderLayer;
import at.dotpoint.exception.UnsupportedMethodException;
import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;
import js.html.CanvasRenderingContext2D;

/**
 * 
 */
class ARenderable extends DisplayComponent implements IRenderable
{

    @:isVar public var depth(get,set):Int = 0;
    @:isVar public var enabled(get,set):Bool = true;

    private var isRenderingDirty:Bool;
    private var dirtyRegion:Rectangle;

    //
    public function new( ?type:ComponentType )
    {
        if( type == null )
            type = RenderableType.CANVAS;

        super( type );

        this.dirtyRegion = new Rectangle();
        this.isRenderingDirty = true;
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function get_enabled( ):Bool return this.enabled;
    private function set_enabled( value:Bool ):Bool
    {
        return this.enabled = value;
    }

    //
    private function get_depth( ):Int return depth;
    private function set_depth( value:Int ):Int
    {
        if( value != this.depth ){
            this.dispatch( RenderableSignal.DEPTH_CHANGED, SignalPropagation.NONE );
        }

        return this.depth = value;
    }

    // ************************************************************************ //
    // Rendering
    // ************************************************************************ //

    //
    public function invalidate():Void
    {
        this.isRenderingDirty = true;
    }

    /**
     * add the regions to the your containers layer
     */
    public function clear( layer:RenderLayer ):Void
    {
        if( !this.isRenderingDirty ) // nothing changed: old regions are valid, but not to be used
            return;

        layer.dirtyRegions.push( this.dirtyRegion );
    }

    /**
     * must calculate DirtyRegions for the current rendering call
     */
    public function render( layer:RenderLayer ):Void
    {
        if( !this.isRenderingDirty )
            return;

        //
        this.updateDirtyRegions();
        this.draw( layer.context );

        this.isRenderingDirty = false;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    /**
     * calculate the regions that would change if the display would render
     * right now. override this method if the object bounding isn't quite right.
     */
    private function updateDirtyRegions():Void
    {
        this.boundings.get( this.dirtyRegion, Space.WORLD );
    }

    //
    private function draw( ctx:CanvasRenderingContext2D ):Void
    {
        throw new UnsupportedMethodException();
    }

}
