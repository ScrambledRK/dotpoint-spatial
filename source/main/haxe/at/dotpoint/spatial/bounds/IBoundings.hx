package at.dotpoint.spatial.bounds;

import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;

//
interface IBoundings
{
    public var width(get,set):Float;
    public var height(get,set):Float;

    public function get( ?output:Rectangle, ?space:Space ):Rectangle;
    public function set( input:Rectangle, ?space:Space ):Rectangle;

    public function invalidate( space:Space ):Void;
}