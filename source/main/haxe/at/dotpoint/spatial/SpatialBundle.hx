package at.dotpoint.spatial;

import at.dotpoint.datastructure.entity.AComponentBundle;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.hierarchy.ITreeComponent;
import at.dotpoint.datastructure.entity.hierarchy.TreeContainer;
import at.dotpoint.datastructure.entity.hierarchy.TreeIterator;
import at.dotpoint.datastructure.entity.hierarchy.TreeObject;
import at.dotpoint.datastructure.entity.hierarchy.TreeSignal;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.datastructure.entity.IEntity.IComponentProvider;
import at.dotpoint.datastructure.graph.TreeTraversal;
import at.dotpoint.datastructure.iterator.IResetIterator;
import at.dotpoint.exception.NullArgumentException;
import at.dotpoint.math.Space;
import at.dotpoint.spatial.bounds.AABB;
import at.dotpoint.spatial.bounds.AABBContainer;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.ISpatialBundle.SpatialBundleType;
import at.dotpoint.spatial.transform.ITransform;
import at.dotpoint.spatial.transform.Transform;

/**
 *
 */
class SpatialBundle extends AComponentBundle implements ISpatialBundle
{

    public var transform(default,null):ITransform;
    public var boundings(default,null):IBoundings;
    public var hierarchy(default,null):ITreeComponent<ISpatialBundle>;

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( type:ComponentType, transform:ITransform, boundings:IBoundings,
                         hierarchy:ITreeComponent<ISpatialBundle> )
    {
        super( type );

        if( transform == null )
            throw new NullArgumentException("ITransform");

        if( boundings == null )
            throw new NullArgumentException("IBoundings");

        if( hierarchy == null )
            throw new NullArgumentException("ITreeComponent");

        this.transform = transform;
        this.boundings = boundings;
        this.hierarchy = hierarchy;
    }

    //
    public static function create( type:ComponentType ):SpatialBundle
    {
        var transform:ITransform = null;
        var boundings:IBoundings = null;
        var hierarchy:ITreeComponent<ISpatialBundle> = null;

        //
        switch( type )
        {
            case SpatialBundleType.OBJECT:
            {
                transform = new Transform();
                boundings = new AABB();
                hierarchy = new TreeObject<ISpatialBundle>( type );
            }

            case SpatialBundleType.CONTAINER:
            {
                transform = new Transform();
                boundings = new AABBContainer();
                hierarchy = new TreeContainer<ISpatialBundle>( type );
            }
        }

        //
        var bundle = new SpatialBundle( type, transform, boundings, hierarchy );
            bundle.transform.setBundle( bundle );
            bundle.boundings.setBundle( bundle );
            bundle.hierarchy.setBundle( bundle );

        return bundle;
    }

    //
    public static function from( manager:IComponentProvider, type:ComponentType ):SpatialBundle
    {
        var transform:ITransform = cast manager.getComponent( TransformType.TRANSFORM );
        var boundings:IBoundings = cast manager.getComponent( BoundingsType.AABB );
        var hierarchy:ITreeComponent<ISpatialBundle> = cast manager.getComponent( type );

        if( transform == null || boundings == null || hierarchy == null )
            throw 'missing components for ISpatialBundle from manager: $manager of type: $type';

        //
        var bundle = new SpatialBundle( type, transform, boundings, hierarchy );

        if( transform.getBundle() == null ) transform.setBundle( bundle );
        if( boundings.getBundle() == null ) boundings.setBundle( bundle );
        if( hierarchy.getBundle() == null ) hierarchy.setBundle( bundle );

        return bundle;
    }

    // ************************************************************************ //
    // ComponentManager
    // ************************************************************************ //

    //
    public function getComponent( type:ComponentType ):IComponent
    {
        if( this.transform.type == type )
            return this.transform;

        if( this.boundings.type == type  )
            return this.boundings;

        if( this.hierarchy.type == type )
            return this.hierarchy;

        return null;
    }

    //
    public function getComponents( ):Array<IComponent>
    {
        return [this.transform, this.boundings, this.hierarchy];
    }

    // ************************************************************************ //
    // Events
    // ************************************************************************ //

    //
    public function onEntitySignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        switch( signal )
        {
            case TransformSignal.CHANGED:           // local and/or world matrix changed
                this.onTransformChanged( phase );

            case BoundingsSignal.CHANGED:           // model bounds changed
                this.onBoundingsChanged( phase );

            case TreeSignal.CHANGED:                // got removed from or added to a container
                this.onHierarchyChanged( phase );
        }
    }

    //
    private function onTransformChanged( phase:SignalPropagation ):Void
    {
        switch( phase )
        {
            case SignalPropagation.NONE:        // this transform changed
            {
                this.boundings.invalidate( Space.LOCAL );
                this.boundings.invalidate( Space.WORLD );

                this.hierarchy.dispatch( TransformSignal.CHANGED, SignalPropagation.CHILDREN );
                this.hierarchy.dispatch( TransformSignal.CHANGED, SignalPropagation.PARENTS );
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
    private function onBoundingsChanged( phase:SignalPropagation ):Void
    {
        switch( phase )
        {
            case SignalPropagation.NONE:        // this bounds changed
            {
                this.hierarchy.dispatch( BoundingsSignal.CHANGED, SignalPropagation.PARENTS );
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
    private function onHierarchyChanged( phase:SignalPropagation ):Void
    {
        switch( phase )
        {
            case SignalPropagation.NONE:        // this got added/removed
            {
                this.transform.invalidate( Space.WORLD );
                this.boundings.invalidate( Space.WORLD );

                this.hierarchy.dispatch( TreeSignal.CHANGED, SignalPropagation.PARENTS );
                this.hierarchy.dispatch( TreeSignal.CHANGED, SignalPropagation.CHILDREN );
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
    public var parent(get,never):ISpatialBundle;
    public var children(get,never):IResetIterator<ISpatialBundle>;

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
    public function addChild( entity:ISpatialBundle ):Void {
        this.hierarchy.addChild( entity.hierarchy );
    }

    //
    public function removeChild( entity:ISpatialBundle ):Void {
        this.hierarchy.removeChild( entity.hierarchy );
    }

    //
    inline private function get_parent():ISpatialBundle {
        return this.hierarchy.parent != null ? this.hierarchy.parent.getValue() : null;
    }

    //
    inline private function get_children():IResetIterator<ISpatialBundle>
    {
        return new TreeIterator<ISpatialBundle>( this.hierarchy, TreeTraversal.IMMEDIATE_ONLY );
    }

}