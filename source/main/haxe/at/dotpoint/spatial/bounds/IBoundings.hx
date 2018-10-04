package at.dotpoint.spatial.bounds;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;

//
interface IBoundings extends IComponent
{
    public var width(get,set):Float;
    public var height(get,set):Float;

    public function get( ?output:Rectangle, ?space:Space ):Rectangle;
    public function set( input:Rectangle, ?space:Space ):Rectangle;

    public function invalidate( space:Space ):Void;
}

//
class BoundingsSignal
{
    public static var CHANGED(default,never):SignalType = new SignalType("Boundings.CHANGED");
}

//
class BoundingsType
{
    public static var AABB(default,never):ComponentType = new ComponentType( "Boundings.AABB" );
}