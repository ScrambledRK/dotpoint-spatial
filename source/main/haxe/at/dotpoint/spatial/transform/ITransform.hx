package at.dotpoint.spatial.transform;

import at.dotpoint.math.Space;
import at.dotpoint.math.tensor.Matrix3;
import at.dotpoint.math.tensor.Vector2;

//
interface ITransform
{
    public var x(get,set):Float;
    public var y(get,set):Float;

    public function getPosition( output:Vector2, ?space:Space ):Vector2;
    public function setPosition( input:Vector2, ?space:Space ):Vector2;

    public function getRotation( output:Float, ?space:Space ):Float;
    public function setRotation( input:Float, ?space:Space ):Float;

    public function getScale( output:Vector2, ?space:Space ):Vector2;
    public function setScale( input:Vector2, ?space:Space ):Vector2;

    public function getMatrix( output:Matrix3, ?space:Space ):Matrix3;
    public function setMatrix( input:Matrix3, ?space:Space ):Matrix3;

    public function invalidate( space:Space ):Void;
}