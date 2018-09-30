package at.dotpoint.math.geometry;

import at.dotpoint.math.tensor.Vector2;

/**
 *
 */
class Line
{
    public var a:Vector2;
    public var b:Vector2;

    public function new( ?a:Vector2, ?b:Vector2 )
    {
        this.a = a != null ? a : new Vector2();
        this.b = b != null ? b : new Vector2();
    }

    //
    public function length( squared:Bool = false ):Float
    {
        return a.distance( b, squared );
    }

    //
    public function isIntersecting( other:Line, ?intersection:Vector2 ):Bool
    {
        var x1 = this.a.x;
        var y1 = this.a.y;
        var x2 = this.b.x;
        var y2 = this.b.y;
        var x3 = other.a.x;
        var y3 = other.a.y;
        var x4 = other.b.x;
        var y4 = other.b.y;

        var d = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
        if( d == 0 ) return false;

        if( intersection != null )
        {
            var ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / d;

            intersection.x = x1 + (x2 - x1) * ua;
            intersection.y = y1 + (y2 - y1) * ua;
        }

        return true;
    }


}
