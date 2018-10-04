package at.dotpoint.display.entity;

import at.dotpoint.datastructure.image.Bitmap;
import at.dotpoint.display.renderable.ImageRenderable;

//
class Image extends DisplayEntity
{
    public function new( src:Bitmap, ?name:String ) {
        super( new ImageRenderable(src), name );
    }
}


