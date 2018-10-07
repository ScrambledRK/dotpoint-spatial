package at.dotpoint.spatial.entity;

import at.dotpoint.datastructure.graph.TreeTraversal;
import at.dotpoint.datastructure.entity.AEntity;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.datastructure.iterator.IResetIterator;
import at.dotpoint.spatial.ISpatialBundle.SpatialBundleType;

//
class SpatialObject extends SpatialEntity
{
    public function new( ?name:String ) super( SpatialBundleType.OBJECT, name );
}

//
class SpatialContainer extends SpatialEntity
{
    public function new( ?name:String ) super( SpatialBundleType.CONTAINER, name );

    //
    public function children( ?traversal:TreeTraversal ):IResetIterator<ISpatialBundle>
    {
        return this.spatial.children( traversal );
    }

    //
    public function addChild( bundle:ISpatialBundle ):Void {
        this.spatial.addChild( bundle );
    }

    //
    public function removeChild( bundle:ISpatialBundle ):Void {
        this.spatial.removeChild( bundle );
    }
}

/**
 *
 */
class SpatialEntity extends AEntity implements ISpatialEntity
{

    //
    public var spatial(default,null):SpatialBundle;

    //
    public function new( type:ComponentType, ?name:String )
    {
        super( name );

        this.spatial = SpatialBundle.create( type );
        this.bindBundle( this.spatial, this );
    }

    // ************************************************************************ //
    // IEntity
    // ************************************************************************ //

    //
    public function onComponentSignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        this.spatial.onEntitySignal( origin, signal, phase );
    }

    //
    public function getBundle( type:ComponentType ):IComponentBundle
    {
        if( this.spatial.type == type )
            return this.spatial;

        return null;
    }

    //
    public function getBundles( ):Array<IComponentBundle>
    {
        return [this.spatial];
    }

    //
    public function getComponent( type:ComponentType ):IComponent
    {
        return this.spatial.getComponent( type );
    }

    //
    public function getComponents( ):Array<IComponent>
    {
        return this.spatial.getComponents();
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

    private var parent(get,never):ISpatialBundle;


    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private inline function get_x( ):Float { return this.spatial.x; }
    private inline function set_x( value:Float ):Float
    {
        return this.spatial.x = value;
    }

    //
    private inline function get_y( ):Float { return this.spatial.y; }
    private inline function set_y( value:Float ):Float
    {
        return this.spatial.y = value;
    }

    //
    private inline function get_width( ):Float { return this.spatial.width; }
    private inline function set_width( value:Float ):Float
    {
        return this.spatial.width = value;
    }

    //
    private inline function get_height( ):Float { return this.spatial.height; }
    private inline function set_height( value:Float ):Float
    {
        return this.spatial.height = value;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //
    // TreeComponent

    //
    inline private function get_parent():ISpatialBundle {
        return this.spatial.parent;
    }

}

