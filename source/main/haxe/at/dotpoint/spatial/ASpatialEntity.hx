package at.dotpoint.spatial;

import at.dotpoint.datastructure.graph.TreeTraversal;
import at.dotpoint.datastructure.entity.hierarchy.TreeIterator;
import at.dotpoint.datastructure.iterator.TransformIterator;
import at.dotpoint.datastructure.iterator.ArrayIterator;
import at.dotpoint.datastructure.iterator.IResetIterator;
import at.dotpoint.datastructure.entity.AEntity;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.hierarchy.ITreeComponent;
import at.dotpoint.datastructure.entity.hierarchy.TreeSignal;
import at.dotpoint.math.Space;
import at.dotpoint.spatial.bounds.BoundingsSignal;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;
import at.dotpoint.spatial.transform.TransformSignal;

/**
 *
 */
class ASpatialEntity<T:ISpatialEntity<T>> extends AEntity implements ISpatialEntity<T>
{

    @:isVar public var transform(default,null):ITransform;
    @:isVar public var boundings(default,null):IBoundings;
    @:isVar public var spatial(default,null):ITreeComponent<T>;

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( ?name:String )
    {
        super( name );
    }

    // ************************************************************************ //
    // Events
    // ************************************************************************ //

    //
    override public function onComponentSignal( signal:SignalType, type:SignalPropagation ):Void
    {
        switch( signal )
        {
            case TransformSignal.CHANGED:           // local and/or world matrix changed
                this.onTransformChanged( type );

            case BoundingsSignal.CHANGED:           // model bounds changed
                this.onBoundingsChanged( type );

            case TreeSignal.CHANGED:                // got removed from or added to a container
                this.onHierarchyChanged( type );
        }
    }

    //
    private function onTransformChanged( signal:SignalPropagation ):Void
    {
        switch( signal )
        {
            case SignalPropagation.NONE:        // this transform changed
            {
                this.boundings.invalidate( Space.LOCAL );
                this.boundings.invalidate( Space.WORLD );

                this.spatial.dispatch( TransformSignal.CHANGED, SignalPropagation.CHILDREN );
                this.spatial.dispatch( TransformSignal.CHANGED, SignalPropagation.PARENTS );
            }

            case SignalPropagation.CHILDREN:    // parent transform changed
            {
                this.transform.invalidate( Space.WORLD );
                this.boundings.invalidate( Space.WORLD );
            }

            case SignalPropagation.PARENTS:     // child transform changed
            {
                this.boundings.invalidate( Space.LOCAL );
                this.boundings.invalidate( Space.WORLD );
            }
        }
    }

    //
    private function onBoundingsChanged( signal:SignalPropagation ):Void
    {
        switch( signal )
        {
            case SignalPropagation.NONE:        // this bounds changed
            {
                this.spatial.dispatch( BoundingsSignal.CHANGED, SignalPropagation.PARENTS );
            }

            case SignalPropagation.CHILDREN:    // parent bounds changed
            {
                //;
            }

            case SignalPropagation.PARENTS:     // child bounds changed
            {
                this.boundings.invalidate( Space.LOCAL );
                this.boundings.invalidate( Space.WORLD );
            }
        }
    }

    //
    private function onHierarchyChanged( signal:SignalPropagation ):Void
    {
        switch( signal )
        {
            case SignalPropagation.NONE:        // this got added/removed
            {
                this.transform.invalidate( Space.WORLD );
                this.boundings.invalidate( Space.WORLD );

                this.spatial.dispatch( TreeSignal.CHANGED, SignalPropagation.PARENTS );
                this.spatial.dispatch( TreeSignal.CHANGED, SignalPropagation.CHILDREN );
            }

            case SignalPropagation.CHILDREN:    // parent got added/removed
            {
                this.transform.invalidate( Space.WORLD );
                this.boundings.invalidate( Space.WORLD );
            }

            case SignalPropagation.PARENTS:     // child got added/removed
            {
                this.boundings.invalidate( Space.WORLD );
                this.boundings.invalidate( Space.LOCAL );
            }
        }
    }

    // ************************************************************************ //
    // Helper
    // ************************************************************************ //

    //
    public var x(get,set):Float;
    public var y(get,set):Float;

    //
    public var width(get,set):Float;
    public var height(get,set):Float;

    //
    private var parent(get,never):T;
    private var children(get,never):IResetIterator<T>;

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private inline function get_x( ):Float { return this.transform.x; }
    private inline function set_x( value:Float ):Float
    {
        return this.transform.x = value;
    }

    //
    private inline function get_y( ):Float { return this.transform.y; }
    private inline function set_y( value:Float ):Float
    {
        return this.transform.y = value;
    }

    //
    private inline function get_width( ):Float { return this.boundings.width; }
    private inline function set_width( value:Float ):Float
    {
        return this.boundings.width = value;
    }

    //
    private inline function get_height( ):Float { return this.boundings.height; }
    private inline function set_height( value:Float ):Float
    {
        return this.boundings.height = value;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //
    // TreeComponent

    //
    public function addChild( entity:T ):Void {
        this.spatial.addChild( entity.spatial );
    }

    //
    public function removeChild( entity:T ):Void {
        this.spatial.removeChild( entity.spatial );
    }

    //
    inline private function get_parent():T {
        return this.spatial.parent != null ? this.spatial.parent.entity: null;
    }

    //
    inline private function get_children():IResetIterator<T>
    {
        return new TreeIterator<T>( cast this.spatial, TreeTraversal.IMMEDIATE_ONLY );
    }

}