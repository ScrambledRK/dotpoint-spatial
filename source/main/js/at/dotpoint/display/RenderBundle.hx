package at.dotpoint.display;

import at.dotpoint.datastructure.entity.AComponentBundle;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.display.IRenderBundle.RenderBundleType;
import at.dotpoint.display.rendering.IRenderViewport.RenderViewportSignal;
import at.dotpoint.display.rendering.RenderLayer;
import at.dotpoint.display.rendering.RenderViewport;
import at.dotpoint.exception.IndexBoundsException;

/**
 *
 */
class RenderBundle extends AComponentBundle implements IRenderBundle
{

    private var viewport:RenderViewport;
    private var layers:Array<RenderLayer>;

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( viewport:RenderViewport, numLayer:Int = 1, ?type:ComponentType )
    {
        if( type == null )
            type = RenderBundleType.CANVAS;

        super( type );

        this.viewport = viewport;
        this.layers = new Array<RenderLayer>();

        this.createLayer( numLayer );
    }

    // ************************************************************************ //
    // ComponentManager
    // ************************************************************************ //

    //
    public function getComponent( type:ComponentType ):IComponent
    {
        if( this.viewport.type == type )
            return this.viewport;

        return null;
    }

    //
    public function getComponents( ):Array<IComponent>
    {
        return [this.viewport];
    }

    // ************************************************************************ //
    // Events
    // ************************************************************************ //

    //
    public function onEntitySignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        switch( signal )
        {
            case RenderViewportSignal.TICK:
            {
                 for( layer in layers )
                    layer.render();
            }

            case RenderViewportSignal.RESIZE:
            {
                this.resizeLayers();    // TODO: resize using scaleMode and stageSize
            }
        }
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    public function addChildAt( child:IDisplayBundle, layer:Int ):Void
    {
        if( layer < 0 || layer > this.layers.length )
            throw new IndexBoundsException( layer, 0, this.layers.length );

        this.layers[layer].addRenderItem( child );
    }

    //
    public function removeChildAt( child:IDisplayBundle, layer:Int ):Void
    {
        if( layer < 0 || layer > this.layers.length )
            throw new IndexBoundsException( layer, 0, this.layers.length );

        this.layers[layer].removeRenderItem( child );
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private function createLayer( count:Int ):Void
    {
        for( j in 0...count )
        {
            var layer:RenderLayer = this.layers[j] = new RenderLayer();
                layer.depth = 1 + j;

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
