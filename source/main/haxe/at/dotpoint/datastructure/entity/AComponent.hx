package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;
import at.dotpoint.exception.NullArgumentException;

/**
 *
 */
class AComponent<T:IComponentBundle> implements IComponent
{

    //
    public var type(default,null):ComponentType;
    @:isVar public var entity(get,set):IEntity;
    @:isVar public var bundle(get,set):T;

    //
    public function new( type:ComponentType )
    {
        this.type = type;

        if( this.type == null )
            throw new NullArgumentException("ComponentType");
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function get_entity( ):IEntity return entity;
    private function set_entity( value:IEntity ):IEntity
    {
        if( this.entity == value )
            return value;

        if( this.entity != null )
            throw "unsetting an already set entity of a component is not allowed";

        if( this.entity == null && value != null )
        {
            this.entity = value;

            if( this.bundle != null )
                this.initialize();
        }

        return value;
    }

    //
    private function get_bundle( ):T return bundle;
    private function set_bundle( value:T ):T
    {
        if( this.bundle == value )
            return value;

        if( this.bundle != null )
            throw "unsetting an already set bundle of a component is not allowed";

        if( this.bundle == null && value != null )
        {
            this.bundle = value;

            if( this.entity != null )
                this.initialize();
        }

        return value;
    }

    //
    public function setBundle( bundle:IComponentBundle ):IComponentBundle
    {
        this.bundle = cast bundle;

        if( this.bundle == null && bundle != null )
            throw "could not cast bundle to required type";

        return bundle;
    }

    //
    public function getBundle():IComponentBundle
    {
        return this.bundle;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private function initialize():Void
    {
        //;
    }

    //
    private function dispatch( signal:SignalType, propagation:SignalPropagation ):Void
    {
        this.entity.onComponentSignal( this.type, signal, propagation );
    }

    //
    private function toString():String
    {
        return this.type.toString();
    }
}
