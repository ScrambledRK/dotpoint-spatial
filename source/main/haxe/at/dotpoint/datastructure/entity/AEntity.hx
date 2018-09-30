package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.exception.UnsupportedMethodException;

/**
 *
 */
class AEntity implements IEntity
{

    //
    @:isVar public var name(get,set):String;
    @:isVar public var alive(get,set):Bool;

    //
    public function new( ?name:String )
    {
        this.name = name;
        this.alive = true;
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function get_name( ):String { return name; }
    private function set_name( value:String ):String
    {
        return this.name = value;
    }

    //
    private function get_alive( ):Bool { return this.alive; }
    private function set_alive( value:Bool ):Bool
    {
        return this.alive = value;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public function onComponentSignal( signal:SignalType, type:SignalPropagation ):Void
    {
        throw new UnsupportedMethodException();
    }

    //
    public function toString()
    {
        return name != null ? name : Type.getClassName( Type.getClass( this ) );
    }
}
