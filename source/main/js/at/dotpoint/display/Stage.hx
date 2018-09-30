package at.dotpoint.display;

import at.dotpoint.exception.UnsupportedMethodException;
import at.dotpoint.spatial.bounds.AABBContainer;
import at.dotpoint.spatial.transform.Transform;
import at.dotpoint.display.renderable.ADisplayEntity;
import at.dotpoint.datastructure.entity.AEntity;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.display.renderable.IDisplayEntity.IDisplayObject;
import at.dotpoint.display.rendering.RenderLayer;
import at.dotpoint.display.rendering.RenderViewport;
import at.dotpoint.display.rendering.ScaleMode;
import at.dotpoint.display.rendering.ViewportSignal;
import at.dotpoint.exception.IndexBoundsException;
import at.dotpoint.math.geometry.Rectangle;
import js.html.DivElement;


/**
 *
 */
class Stage extends AEntity
{

    //
    private var viewport:RenderViewport;
    private var layers:Array<RenderLayer>;

    @:isVar public var scaleMode(get,set):ScaleMode;
    @:isVar public var stageSize(get,set):Rectangle;

    //
    public function new( container:DivElement, numLayer:Int = 1 )
    {
        super();

        //
        this.viewport = new RenderViewport( this, container );
        this.layers = new Array<RenderLayer>();

        this.scaleMode = ScaleMode.NO_SCALE;
        this.stageSize = new Rectangle();

        this.createLayer( numLayer );
    }

    // ************************************************************************ //
    // getter / setter
    // ************************************************************************ //

    //
    private function get_scaleMode( ):ScaleMode return scaleMode;
    private function set_scaleMode( value:ScaleMode ):ScaleMode
    {
        return this.scaleMode = value;
    }

    //
    private function get_stageSize( ):Rectangle return stageSize;
    private function set_stageSize( value:Rectangle ):Rectangle
    {
        return this.stageSize = value;
    }

    //
    public function addChildAt( child:IDisplayObject, layer:Int ):Void
    {
        if( layer < 0 || layer > this.layers.length )
            throw new IndexBoundsException( layer, 0, this.layers.length );

        this.layers[layer].spatial.addChild( child.spatial );
    }

    //
    public function removeChildAt( child:IDisplayObject, layer:Int ):Void
    {
        if( layer < 0 || layer > this.layers.length )
            throw new IndexBoundsException( layer, 0, this.layers.length );

        this.layers[layer].spatial.removeChild( child.spatial );
    }

    // ************************************************************************ //
    // methods
    // ************************************************************************ //

    //
    override public function onComponentSignal( signal:SignalType, type:SignalPropagation ):Void
    {
        switch( signal )
        {
            case ViewportSignal.TICK:
            {
                for( layer in layers )
                    layer.render();
            }

            case ViewportSignal.RESIZE:
            {
                this.resizeLayers();    // TODO: resize using scaleMode and stageSize
            }
        }
    }

    //
    private function createLayer( count:Int ):Void
    {
        for( j in 0...count )
        {
            var layer:RenderLayer = this.layers[j] = new RenderLayer();
            this.viewport.container.appendChild( layer.canvas );
        }
    }

    //
    private function resizeLayers():Void
    {
        var w:Int = Std.int( this.viewport.boundings.width );
        var h:Int = Std.int( this.viewport.boundings.height );

        for( layer in this.layers )
        {
            var canvas = layer.canvas;
                canvas.width  = w;
                canvas.height = h;
                canvas.style.width  = w + "px";
                canvas.style.height = h + "px";
        }
    }
}
