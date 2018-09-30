package at.dotpoint.math.geometry;

import at.dotpoint.math.Axis.Direction;
import at.dotpoint.math.Axis.Diagonal;
import at.dotpoint.math.BasicMath;
import at.dotpoint.math.tensor.Vector2;

/**
 *
 */
class Rectangle
{

    public var min:Vector2;
    public var max:Vector2;

    public var width(get,set):Float;
    public var height(get,set):Float;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    //
    public function new( ?w:Float, ?h:Float )
    {
        this.min = new Vector2();
        this.max = new Vector2();
        this.setEmpty();

        //
        if( w != null )
            this.width = w;

        if( h != null )
            this.height = h;
    }

    //
    public function clone( ?instance:Rectangle ):Rectangle
    {
        if( instance == null )
            instance = new Rectangle();

        instance.min.x 		= this.min.x;
        instance.min.y 		= this.min.y;
        instance.max.x 		= this.max.x;
        instance.max.y 		= this.max.y;

        return instance;
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    private function get_width():Float { return this.max.x - this.min.x; }
    private function set_width( value:Float ):Float
    {
        if( this.isEmpty() )
            this.min.x = 0;

        return this.max.x = this.min.x + value;
    }

    //
    private function get_height():Float { return this.max.y - this.min.y; }
    private function set_height( value:Float ):Float
    {
        if( this.isEmpty() )
            this.min.y = 0;

        return this.max.y = this.min.y + value;
    }

    //
    public function setZero():Rectangle
    {
        this.min.x = 0;
        this.min.y = 0;
        this.max.x = 0;
        this.max.y = 0;

        return this;
    }

    //
    public function setEmpty():Rectangle
    {
        this.min.x =  1;
        this.min.y =  1;
        this.max.x = -1;
        this.max.y = -1;

        return this;
    }

    //
    public function isEmpty():Bool {
        return this.width < 0 || this.height < 0;
    }

    //
    public function equals( other:Rectangle ):Bool {
        return this.min.equals( other.min ) && this.max.equals( other.max );
    }

    //
    public function equalsComponents( x:Float, y:Float, w:Float, h:Float ):Bool
    {
        return BasicMath.equals( min.x, x ) && BasicMath.equals( min.y, y )
            && BasicMath.equals( width, w ) && BasicMath.equals( height, h );
    }

    // ----------------------------------------------------------------------- //
    // ----------------------------------------------------------------------- //

    //
    public function visitLine( orientation:Direction, output:Line ):Void
    {
        switch( orientation )
        {
            case Direction.TOP:
                {
                    this.visitCorner( Diagonal.TOP_LEFT, output.a );
                    this.visitCorner( Diagonal.TOP_RIGHT, output.b );
                }

            case Direction.RIGHT:
                {
                    this.visitCorner( Diagonal.TOP_RIGHT, output.a );
                    this.visitCorner( Diagonal.BOTTOM_RIGHT, output.b );
                }

            case Direction.BOTTOM:
                {
                    this.visitCorner( Diagonal.BOTTOM_RIGHT, output.a );
                    this.visitCorner( Diagonal.BOTTOM_LEFT, output.b );
                }

            case Direction.LEFT:
                {
                    this.visitCorner( Diagonal.BOTTOM_LEFT, output.a );
                    this.visitCorner( Diagonal.TOP_LEFT, output.b );
                }
        }
    }

    //
    public function visitCorner( orientation:Diagonal, output:Vector2 ):Void
    {
        this.visitPoint( SpatialSettings.getCorner( orientation ), output );
    }

    //
    public function visitPoint( relativ:Vector2, output:Vector2 ):Void
    {
        if( this.isEmpty() )
            throw "rectangle is empty";

        output.x = min.x + (max.x - min.x) * relativ.x;
        output.y = min.y + (max.y - min.y) * relativ.y;
    }

    // ************************************************************************ //
    // operations
    // ************************************************************************ //

    //
    public function isRectangleInside( other:Rectangle, withTouch:Bool = false ):Bool
    {
        if( this.isEmpty() || other.isEmpty() )
            return false;

        return this.isPointInside( other.min, withTouch ) && this.isPointInside( other.max, withTouch );
    }

    //
    public function isLineInside( other:Line, withTouch:Bool = false ):Bool
    {
        if( this.isEmpty() )
            return false;
        
        return this.isPointInside( other.a, withTouch ) && this.isPointInside( other.b, withTouch );
    }

    //
    public function isPointInside( point:Vector2, withTouch:Bool = false ):Bool
    {
        if( this.isEmpty() )
            return false;

        if( withTouch )
        {
            if( point.x <= this.min.x )
                return false;

            if( point.y <= this.min.y )
                return false;

            if( point.x >= this.max.x )
                return false;

            if( point.y >= this.max.y )
                return false;
        }
        else
        {
            if( point.x < this.min.x )
                return false;

            if( point.y < this.min.y )
                return false;

            if( point.x > this.max.x )
                return false;

            if( point.y > this.max.y )
                return false;
        }

        return true;
    }

    // ----------------------------------------------------------------------- //
    // ----------------------------------------------------------------------- //

    //
    public function isRectangleIntersecting( other:Rectangle ):Bool
    {
        if( this.isEmpty() || other.isEmpty() )
            return false;

        //
        var line:Line = new Line();

        other.visitLine( Direction.TOP, line );     if( isLineIntersecting( line ) ) return true;
        other.visitLine( Direction.RIGHT, line );   if( isLineIntersecting( line ) ) return true;
        other.visitLine( Direction.BOTTOM, line );  if( isLineIntersecting( line ) ) return true;
        other.visitLine( Direction.LEFT, line );    if( isLineIntersecting( line ) ) return true;

        return false;
    }

    //
    public function isLineIntersecting( other:Line ):Bool
    {
        if( this.isEmpty() )
            return false;

        //
        var line:Line = new Line();

        this.visitLine( Direction.TOP, line );     if( other.isIntersecting( line ) ) return true;
        this.visitLine( Direction.RIGHT, line );   if( other.isIntersecting( line ) ) return true;
        this.visitLine( Direction.BOTTOM, line );  if( other.isIntersecting( line ) ) return true;
        this.visitLine( Direction.LEFT, line );    if( other.isIntersecting( line ) ) return true;

        return false;
    }
    
    // ----------------------------------------------------------------------- //
    // ----------------------------------------------------------------------- //

    //
    public function insertRectangle( other:Rectangle ):Rectangle
    {
        if( other.isEmpty() )
            return this;

        this.insertPoint( other.min );
        this.insertPoint( other.max );

        return this;
    }

    //
    public function insertLine( other:Line ):Rectangle
    {
        this.insertPoint( other.a );
        this.insertPoint( other.b );

        return this;
    }

    //
    public function insertPoint( point:Vector2 ):Rectangle
    {
        if( this.isEmpty() )
        {
            this.min.x = point.x;
            this.min.y = point.y;

            this.max.x = point.x;
            this.max.y = point.y;
        }
        else
        {
            if( point.x < this.min.x )
                this.min.x = point.x;

            if( point.y < this.min.y )
                this.min.y = point.y;

            if( point.x > this.max.x )
                this.max.x = point.x;

            if( point.y > this.max.y )
                this.max.y = point.y;
        }

        return this;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public function toString():String
    {
        return "{x:" + this.min.x + " y:" + this.min.y + " w:" + this.width + " h:" + this.height + "}";
    }
}
