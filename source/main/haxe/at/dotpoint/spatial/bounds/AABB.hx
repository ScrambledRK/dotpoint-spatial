package at.dotpoint.spatial.bounds;

import at.dotpoint.math.BasicMath;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.math.geometry.Rectangle;
import at.dotpoint.math.Space;
import at.dotpoint.math.tensor.Matrix3;
import at.dotpoint.spatial.bounds.IBoundings;

/**
 *
 */
class AABB extends ASpatialComponent<ISpatialEntity<Dynamic>> implements IBoundings
{

    private var model:Rectangle;
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

        this.model = new Rectangle();
        this.local = new Rectangle();
        this.world = new Rectangle();

        this.isLocalDirty = false;
        this.isWorldDirty = false;
    }

    // ************************************************************************ //
    // Validation
    // ************************************************************************ //

    /**
     * given space has been modified, mark other spaces invalid and dispatch change event
     */
    private function notify():Void
    {
        this.entity.onComponentSignal( BoundingsSignal.CHANGED, SignalPropagation.NONE );
    }

    //
    public function invalidate( space:Space ):Void
    {
        switch( space )
        {
            case Space.LOCAL: this.isLocalDirty = true;
            case Space.WORLD: this.isWorldDirty = true;

            case Space.MODEL:
                throw "cannot invalidate model";
        }
    }

    // ************************************************************************ //
    // Rectangle
    // ************************************************************************ //

    //
    public function get( ?output:Rectangle, ?space:Space ):Rectangle
    {
        if( space == null )
            space = Space.MODEL;

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
                return output == null ? model : model.clone( output );
        }
    }

    //
    public function set( input:Rectangle, ?space:Space ):Rectangle
    {
        if( space == null )
            space = Space.MODEL;

        //
        switch( space )
        {
            case Space.WORLD:
            {
                input.clone( world );

                this.isWorldDirty = false;
                this.isLocalDirty = true;

                updateModel( input, space );
            }

            case Space.LOCAL:
            {
                input.clone( local );

                this.isWorldDirty = true;
                this.isLocalDirty = false;

                updateModel( input, space );
            }

            case Space.MODEL:
            {
                input.clone( model );

                this.isWorldDirty = true;
                this.isLocalDirty = true;
            }
        }

        this.notify();
        return input;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private inline function get_width( ):Float { return model.width; }
    private inline function set_width( value:Float ):Float
    {
        if( !BasicMath.equals( model.width, value ) )
            this.isWorldDirty = true;

        return model.width = value;
    }

    //
    private inline function get_height( ):Float { return model.height; }
    private inline function set_height( value:Float ):Float
    {
        if( !BasicMath.equals( model.height, value ) )
            this.isWorldDirty = true;

        return model.height = value;
    }

    // ************************************************************************ //
    // Update
    // ************************************************************************ //

    /**
     * update model
     */
    private function updateModel( value:Rectangle, from:Space ):Void
    {
        var transform = this.transform.getMatrix( new Matrix3(), from );
            transform.inverse();

        model = value.clone( model );
        model.min.transform( transform );
        model.max.transform( transform );
    }

    /**
     * update local from model
     */
    private function updateLocal():Void
    {
        var transform = this.transform.getMatrix( new Matrix3(), Space.LOCAL );

        local = model.clone( local );
        local.min.transform( transform );
        local.max.transform( transform );

        this.isLocalDirty = false;
    }

    /**
     * update local from model
     */
    private function updateWorld():Void
    {
        var transform = this.transform.getMatrix( new Matrix3(), Space.WORLD );

        world = model.clone( world );
        world.min.transform( transform );
        world.max.transform( transform );

        this.isWorldDirty = false;
    }
}
