package at.dotpoint.display.rendering;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.hierarchy.TreeSignal;
import at.dotpoint.display.renderable.IRenderable.RenderableSignal;
import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;
import at.dotpoint.math.tensor.Matrix3;
import at.dotpoint.spatial.entity.SpatialEntity.SpatialContainer;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

/**
 *
 */
class RenderLayer extends SpatialContainer
{

    //
    @:isVar public var dirtyRegions(get, set):Array<Rectangle>;
    @:isVar public var depth(get,set):Int;

    //
    public var canvas(default,null):CanvasElement;
    public var context(default,null):CanvasRenderingContext2D;

    //
    private var renderList:Array<IDisplayBundle>;
    private var isRenderListDirty:Bool;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    //
    public function new()
    {
        super();

        //
        this.canvas = js.Browser.document.createCanvasElement();
        this.context = canvas.getContext2d();

        this.renderList = new Array<IDisplayBundle>();
        this.dirtyRegions = new Array<Rectangle>();

        this.isRenderListDirty = true;
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function get_depth():Int { return this.depth; }
    private function set_depth( value:Int ):Int
    {
        this.canvas.style.zIndex = Std.string( value );
        return this.depth = value;
    }

    //
    private function get_dirtyRegions( ):Array<Rectangle> { return dirtyRegions; }
    private function set_dirtyRegions( value:Array<Rectangle> ):Array<Rectangle>
    {
        return this.dirtyRegions = value;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public function addRenderItem( display:IDisplayBundle ):Void
    {
        if( this.renderList.indexOf( display ) != -1 )
            throw "render item already on layer";

        this.renderList.push( display );
        this.isRenderListDirty = true;
    }

    //
    public function removeRenderItem( display:IDisplayBundle ):Void
    {
        var index = this.renderList.indexOf( display );

        if( index == -1 )
            throw "render item not on layer";

        this.renderList.splice( index, 1 );
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    override public function onComponentSignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        super.onComponentSignal( origin, signal, phase );

        switch( signal )
        {
            case TreeSignal.CHANGED:
                this.isRenderListDirty = true;   // entity got added/removed

            case RenderableSignal.DEPTH_CHANGED:
                this.isRenderListDirty = true;
        }
    }

    // ************************************************************************ //
    // IRenderable
    // ************************************************************************ //

    //
    private function clear():Void
    {
        for( child in this.renderList )
            child.renderable.clear( this );

        // intersect regions with overlapping static/clean render objects
        // invalidate them, get their region again, then repeat until no new regions added ...
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public function render():Void
    {
        this.updateList();
        this.clear();

        //
        for( child in this.renderList )
        {
            var t:Matrix3 = child.transform.getMatrix( new Matrix3(), Space.WORLD );
            context.setTransform( t.m11, t.m12, t.m21, t.m22, t.m31, t.m32 );

            child.renderable.render( this );
        }
    }

    //
    private function updateList():Void
    {
        if( !this.isRenderListDirty )
            return;

        //
        this.isRenderListDirty = false;

        this.renderList.sort( function( a:IDisplayBundle, b:IDisplayBundle ):Int {
             return a.renderable.depth - b.renderable.depth;
        });
    }
}