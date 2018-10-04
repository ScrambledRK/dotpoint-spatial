package at.dotpoint.spatial;

import at.dotpoint.datastructure.entity.AComponent;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.hierarchy.TreeIterator;
import at.dotpoint.datastructure.graph.TreeTraversal;
import at.dotpoint.datastructure.iterator.IResetIterator;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

/**
 *
 */
class SpatialComponent extends AComponent<ISpatialBundle>
{

    //
    public function new( type:ComponentType )
    {
        super( type );
    }

    // ************************************************************************ //
    // Helper
    // ************************************************************************ //

    //
    private var transform(get,never):ITransform;
    private var boundings(get,never):IBoundings;

    //
    private var parent(get,never):ISpatialBundle;
    private var children(get,never):IResetIterator<ISpatialBundle>;

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
    inline private function get_parent():ISpatialBundle {
        return this.bundle.hierarchy.parent != null ? this.bundle.hierarchy.parent.getValue(): null;
    }

    //
    inline private function get_children():IResetIterator<ISpatialBundle>
    {
        return new TreeIterator<ISpatialBundle>( cast this.bundle.hierarchy, TreeTraversal.IMMEDIATE_ONLY );
    }

}
