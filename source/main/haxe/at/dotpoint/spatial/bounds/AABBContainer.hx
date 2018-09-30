package at.dotpoint.spatial.bounds;

import at.dotpoint.exception.UnsupportedMethodException;
import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;

/**
 * 
 */
class AABBContainer extends ASpatialComponent<ISpatialEntity<Dynamic>> implements IBoundings
{

    private var local:Rectangle;
    private var world:Rectangle;

    private var isLocalDirty:Bool;
    private var isWorldDirty:Bool;

    public var width(get,set):Float;
    public var height(get,set):Float;

    //
    public function new( entity:ISpatialEntity<Dynamic> )
    {
        super( entity );

        this.local = new Rectangle();
        this.world = new Rectangle();

        this.isLocalDirty = false;
        this.isWorldDirty = false;
    }

    // ************************************************************************ //
    // Validation
    // ************************************************************************ //

    //
    public function invalidate( space:Space ):Void
    {
        switch( space )
        {
            case Space.LOCAL: this.isLocalDirty = true;
            case Space.WORLD: this.isWorldDirty = true;

            case Space.MODEL:
                throw "model space not supported";
        }
    }

    // ************************************************************************ //
    // Rectangle
    // ************************************************************************ //

    //
    public function get( ?output:Rectangle, ?space:Space ):Rectangle
    {
        if( space == null )
            space = Space.LOCAL;

        switch( space )
        {
            case Space.WORLD:
                {
                    if( this.isWorldDirty )
                        this.updateWorld();

                    return output == null ? world : world.clone( output );
                }

            case Space.LOCAL:
                {
                    if( this.isLocalDirty )
                        this.updateLocal();

                    return output == null ? local : local.clone( output );
                }

            case Space.MODEL:
                throw "model space not supported";
        }
    }

    //
    public function set( input:Rectangle, ?space:Space ):Rectangle
    {
        throw new UnsupportedMethodException("cannot set bounds of container");
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private inline function get_width( ):Float { return local.width; }
    private inline function set_width( value:Float ):Float
    {
        throw new UnsupportedMethodException("cannot set bounds of container");
    }

    //
    private inline function get_height( ):Float { return local.height; }
    private inline function set_height( value:Float ):Float
    {
        throw new UnsupportedMethodException("cannot set bounds of container");
    }

    // ************************************************************************ //
    // Update
    // ************************************************************************ //

    /**
     * update local from model
     */
    private function updateLocal():Void
    {
        world.setEmpty();

        for( child in this.children )
            world.insertRectangle( child.boundings.get( new Rectangle(), Space.LOCAL ) );

        this.isLocalDirty = false;
    }

    /**
     * update local from model
     */
    private function updateWorld():Void
    {
        world.setEmpty();

        for( child in this.children )
            world.insertRectangle( child.boundings.get( new Rectangle(), Space.WORLD ) );

        this.isWorldDirty = false;
    }
}