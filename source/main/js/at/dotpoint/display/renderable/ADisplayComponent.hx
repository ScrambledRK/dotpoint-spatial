package at.dotpoint.display.renderable;

import at.dotpoint.display.renderable.IDisplayEntity.IDisplayObject;
import at.dotpoint.spatial.ASpatialComponent;

/**
 *
 */
class ADisplayComponent<T:IDisplayObject> extends ASpatialComponent<T>
{

    //
    private var renderable(get,never):IRenderable;

    //
    public function new( entity:T )
    {
        super( entity );
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    inline private function get_renderable( ):IRenderable {
        return this.entity.renderable;
    }
}