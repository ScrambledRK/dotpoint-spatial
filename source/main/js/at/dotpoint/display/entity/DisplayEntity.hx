package at.dotpoint.display.entity;

import at.dotpoint.datastructure.entity.AEntity;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.display.IDisplayBundle.DisplayBundleType;
import at.dotpoint.display.renderable.IRenderable;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.ISpatialBundle;
import at.dotpoint.spatial.SpatialBundle;
import at.dotpoint.spatial.transform.ITransform;

/**
 *
 */
class DisplayEntity extends AEntity implements IDisplayEntity
{

    //
    public var spatial(default,null):SpatialBundle;
    public var display(default,null):DisplayBundle;

    //
    public function new( renderable:IRenderable, ?name:String )
    {
        super( name );

        //
        this.spatial = SpatialBundle.create( SpatialBundleType.OBJECT );

        var transform:ITransform = this.spatial.transform;
        var boundings:IBoundings = this.spatial.boundings;

        this.display = new DisplayBundle( DisplayBundleType.SIMPLE, transform, boundings, renderable );
        this.display.renderable.setBundle( display );

        this.bindBundle( this.spatial, this );
        this.bindBundle( this.display, this );
    }

    // ************************************************************************ //
    // IEntity
    // ************************************************************************ //

    //
    public function onComponentSignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        this.spatial.onEntitySignal( origin, signal, phase );
        this.display.onEntitySignal( origin, signal, phase );
    }

    //
    public function getBundle( type:ComponentType ):IComponentBundle
    {
        if( this.spatial.type == type )
            return this.spatial;

        if( this.display.type == type )
            return this.display;

        return null;
    }

    //
    public function getBundles():Array<IComponentBundle>
    {
        return [this.spatial,this.display];
    }

    //
    public function getComponent( type:ComponentType ):IComponent
    {
        var component = this.spatial.getComponent( type );

        if( component == null )
            component = this.display.getComponent( type );

        return component;
    }

    //
    public function getComponents( ):Array<IComponent>
    {
        var list = this.spatial.getComponents();
            list.push( this.display.renderable );

        return list;
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