package at.dotpoint.math;

import at.dotpoint.math.Axis.Diagonal;
import at.dotpoint.math.Axis.Direction;
import at.dotpoint.math.tensor.Vector2;

/**
*
**/
class SpatialSettings
{

    // axis
    public static var X(default,never):Vector2 = new Vector2( 1, 0 );
    public static var Y(default,never):Vector2 = new Vector2( 0, 1 );

    // direction
    public static var TOP(default,never):Vector2       = new Vector2(  0, -1 );
    public static var RIGHT(default,never):Vector2     = new Vector2(  1,  0 );
    public static var BOTTOM(default,never):Vector2    = new Vector2(  0,  1 );
    public static var LEFT(default,never):Vector2      = new Vector2( -1,  0 );

    // diagonal
    public static var TOP_LEFT(default,never):Vector2     = new Vector2(  0, 0 );
    public static var TOP_RIGHT(default,never):Vector2    = new Vector2(  1, 0 );
    public static var BOTTOM_RIGHT(default,never):Vector2 = new Vector2(  1, 1 );
    public static var BOTTOM_LEFT(default,never):Vector2  = new Vector2(  0, 1 );

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public static function getAxis( axis:Axis ):Vector2
    {
        switch( axis )
        {
            case Axis.X: return X;
            case Axis.Y: return Y;
        }
    }

    //
    public static function getDirection( axis:Direction ):Vector2
    {
        switch( axis )
        {
            case Direction.TOP:      return TOP;
            case Direction.RIGHT:    return RIGHT;
            case Direction.BOTTOM:   return BOTTOM;
            case Direction.LEFT:     return LEFT;
        }
    }

    //
    public static function getCorner( axis:Diagonal ):Vector2
    {
        switch( axis )
        {
            case Diagonal.TOP_LEFT:      return TOP_LEFT;
            case Diagonal.TOP_RIGHT:     return TOP_RIGHT;
            case Diagonal.BOTTOM_RIGHT:  return BOTTOM_RIGHT;
            case Diagonal.BOTTOM_LEFT:   return BOTTOM_LEFT;
        }
    }
}

