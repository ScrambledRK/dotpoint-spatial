package at.dotpoint.display.rendering;

import at.dotpoint.datastructure.entity.hierarchy.TreeIterator;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.spatial.bounds.AABBContainer;
import at.dotpoint.spatial.transform.Transform;
import at.dotpoint.datastructure.entity.hierarchy.TreeContainer;
import at.dotpoint.display.renderable.NullRenderable;
import at.dotpoint.display.renderable.IDisplayEntity.IDisplayObject;
import at.dotpoint.display.renderable.ADisplayEntity;
import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;
import at.dotpoint.math.tensor.Matrix3;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

/**
 *
 */
class RenderLayer extends DisplayContainer
{

    //
    @:isVar public var dirtyRegions(get, set):Array<Rectangle>;
    @:isVar public var depth(get,set):Int;

    //
    public var canvas(default,null):CanvasElement;
    public var context(default,null):CanvasRenderingContext2D;

    //
    private var renderList:Array<IDisplayObject>;
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
    override private function onHierarchyChanged( signal:SignalPropagation ):Void
    {
        this.isRenderListDirty = true;   // entity got added/removed
    }

    //
    override private function onRenderableChanged( signal:SignalPropagation ):Void
    {
        this.isRenderListDirty = true;   // z-order changed
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
        this.renderList = new Array<IDisplayObject>();

        for( child in new TreeIterator<IDisplayObject>( this.spatial ) )
        {
            if( child.renderable.enabled )
                this.renderList.push( child );
        }

        //
        this.renderList.sort( function( a:IDisplayObject, b:IDisplayObject ):Int {
             return a.renderable.depth - b.renderable.depth;
        });
    }
}