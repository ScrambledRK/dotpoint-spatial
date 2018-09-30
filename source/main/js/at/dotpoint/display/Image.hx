package at.dotpoint.display;

import at.dotpoint.datastructure.image.Bitmap;
import at.dotpoint.display.renderable.ADisplayEntity.ADisplayObject;
import at.dotpoint.display.renderable.ARenderable;
import js.html.CanvasRenderingContext2D;

//
class Image extends ADisplayObject
{
    public function new( src:Bitmap, ?name:String ) {
        super( new ImageRenderable(src), name );
    }
}

/**
 *
 */
class ImageRenderable extends ARenderable
{

    //
    public var src:js.html.Image;

    //
    public function new( src:Bitmap )
    {
        super();
        this.src = src;
    }

    //
    override private function initialize():Void
    {
        super.initialize();

        this.boundings.width = src.width;
        this.boundings.height = src.height;
    }

    //
    override public function draw( ctx:CanvasRenderingContext2D ):Void
    {
        ctx.drawImage( this.src, 0, 0 );
    }
}
