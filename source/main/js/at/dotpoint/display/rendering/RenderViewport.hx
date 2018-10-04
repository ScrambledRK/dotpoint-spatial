package at.dotpoint.display.rendering;

import at.dotpoint.datastructure.entity.AComponent;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.display.rendering.IRenderViewport.RenderViewportSignal;
import at.dotpoint.display.rendering.IRenderViewport.RenderViewportType;
import at.dotpoint.math.geometry.Rectangle;
import js.html.DivElement;
import js.html.DOMRect;
import js.html.Window;

/**
 *
 */
class RenderViewport extends AComponent<IRenderBundle> implements IRenderViewport
{

    public var window(default, null):Window;
    public var container(default, null):DivElement;
    public var boundings(default, null):Rectangle;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    //
    public function new( container:DivElement, ?type:ComponentType )
    {
        if( type == null )
            type = RenderViewportType.CANVAS;

        super( type );

        this.window = js.Browser.window;
        this.container = container;
        this.boundings = new Rectangle();

        this.window.requestAnimationFrame( this.onAnimationFrame );
    }

    // ************************************************************************ //
    // Update
    // ************************************************************************ //

    //
    private function onAnimationFrame( delta:Float ):Void
    {
        this.checkDimension();
        this.dispatch( RenderViewportSignal.TICK, SignalPropagation.NONE );

        this.window.requestAnimationFrame( this.onAnimationFrame );
    }

    //
    private function checkDimension():Void
    {
        var rect:DOMRect = this.container.getBoundingClientRect();

        var x = Std.int( rect.left );
        var y = Std.int( rect.top );
        var w = Std.int( rect.width );
        var h = Std.int( rect.height );

        //
        if( !boundings.equalsComponents( x, y, w, h ) )
        {
            boundings.min.x = x;
            boundings.min.y = y;
            boundings.width = w;
            boundings.height = h;

            this.dispatch( RenderViewportSignal.RESIZE, SignalPropagation.NONE );
        }
    }


}
