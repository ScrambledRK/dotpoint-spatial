package at.dotpoint.spatial;

import at.dotpoint.datastructure.entity.AComponent;
import at.dotpoint.datastructure.entity.hierarchy.TreeIterator;
import at.dotpoint.datastructure.graph.TreeTraversal;
import at.dotpoint.datastructure.iterator.IResetIterator;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

/**
 *
 */
class ASpatialComponent<T:ISpatialEntity<Dynamic>> extends AComponent<T>
{

    private var parent(get,never):T;
    private var children(get,never):IResetIterator<T>;

    private var transform(get,never):ITransform;
    private var boundings(get,never):IBoundings;

    //
    public function new( entity:T )
    {
        super( entity );
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    inline private function get_transform( ):ITransform {
        return this.entity.transform;
    }

    //
    inline private function get_boundings( ):IBoundings {
        return this.entity.boundings;
    }

    //
    inline private function get_parent():T {
        return this.entity.spatial.parent != null ? this.entity.spatial.parent.entity: null;
    }

    //
    inline private function get_children():IResetIterator<T>
    {
        return new TreeIterator<T>( cast this.entity.spatial, TreeTraversal.IMMEDIATE_ONLY );
    }

}
