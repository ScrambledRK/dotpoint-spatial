package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.exception.NullArgumentException;

/**
 *
 */
class AComponentBundle
{
    //
    public var type(default,null):ComponentType;
    @:isVar public var entity(get,set):IEntity;

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
            throw "unsetting an already set entity of a bundle is not allowed";

        if( this.entity == null && value != null )
        {
            this.entity = value;
            this.initialize();
        }

        return value;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private function initialize():Void
    {
        //;
    }

    //
    private function toString():String
    {
        return this.type.toString();
    }
}
