package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.AEntity;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;

/**
 *
 */
class GenericEntity extends AEntity implements IEntity
{

    //
    public var components(default,null):Array<IComponent>;
    public var bundles(default,null):Array<IComponentBundle>;

    //
    public function new( ?name:String )
    {
        super( name );

        this.components = new Array<IComponent>();
        this.bundles = new Array<IComponentBundle>();
     }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    public function addComponent( component:IComponent ):Void
    {
        if( component.entity != null && component.entity != this )
            throw "component already assigned to an entity: " + component.entity;

        if( this.hasComponent( component.type ) )
            throw "entity already has a component of the same type: " + component.type;

        this.components.push( cast component );
        this.bindComponent( component, this );
    }

    //
    public function hasComponent( type:ComponentType  ):Bool
    {
        return this.getComponent( type ) != null;
    }

    //
    public function getComponent( type:ComponentType ):IComponent
    {
        for( component in this.components )
        {
            if( component.type == type )
                return component;
        }

        return null;
    }

    //
    public function getComponents():Array<IComponent>
    {
        return this.components.concat( new Array<IComponent>() );
    }

    //
    public function addBundle( bundle:IComponentBundle ):Void
    {
        if( bundle.entity != null && bundle.entity != this )
            throw "bundle already assigned to an entity: " + bundle.entity;

        if( this.hasBundle( bundle.type ) )
            throw "entity already has a bundle of the same type: " + bundle.type;

        //
        for( component in bundle.getComponents() )
        {
            if( !this.hasComponent( component.type ) )
                this.addComponent( component );
        }

        //
        this.bundles.push( bundle );
        this.bindBundle( bundle, this );
    }

    //
    public function hasBundle( type:ComponentType ):Bool
    {
        return this.getBundle( type ) != null;
    }

    //
    public function getBundle( type:ComponentType ):IComponentBundle
    {
        for( bundle in this.bundles )
        {
            if( bundle.type == type )
                return bundle;
        }

        return null;
    }

    //
    public function getBundles():Array<IComponentBundle>
    {
        return this.bundles.concat( new Array<IComponentBundle>() );
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public function onComponentSignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        for( bundle in bundles )
            bundle.onEntitySignal( origin, signal, phase );
    }


}
