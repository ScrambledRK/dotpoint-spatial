package at.dotpoint.display;

import at.dotpoint.datastructure.entity.AComponent;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.display.renderable.IRenderable;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

/**
 *
 */
class DisplayComponent extends AComponent<IDisplayBundle>
{
    //
    public function new( type:ComponentType )
    {
        super( type );
    }

    // ************************************************************************ //
    // Helper
    // ************************************************************************ //

    private var transform(get,never):ITransform;
    private var boundings(get,never):IBoundings;
    private var renderable(get,never):IRenderable;

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    inline private function get_transform( ):ITransform {
        return this.bundle.transform;
    }

    //
    inline private function get_boundings( ):IBoundings {
        return this.bundle.boundings;
    }

    //
    inline private function get_renderable( ):IRenderable {
        return this.bundle.renderable;
    }
}
