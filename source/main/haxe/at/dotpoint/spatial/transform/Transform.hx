package at.dotpoint.spatial.transform;

import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.exception.UnsupportedMethodException;
import at.dotpoint.math.BasicMath;
import at.dotpoint.math.Space;
import at.dotpoint.math.tensor.Matrix3;
import at.dotpoint.math.tensor.Vector2;
import at.dotpoint.spatial.transform.ITransform.TransformSignal;
import at.dotpoint.spatial.transform.ITransform.TransformType;

/**
 *
 */
class Transform extends SpatialComponent implements ITransform
{

    private var local:Matrix3;
    private var world:Matrix3;

    private var isLocalDirty:Bool;
    private var isWorldDirty:Bool;

    public var x(get,set):Float;
    public var y(get,set):Float;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    //
    public function new()
    {
        super( TransformType.TRANSFORM );

        this.local = new Matrix3();
        this.world = new Matrix3();

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
        this.dispatch( TransformSignal.CHANGED, SignalPropagation.NONE );

        if( this.isWorldDirty && this.isLocalDirty )
            throw "both world and local matrix are dirty, cannot compute, error error";
    }

    //
    public function invalidate( space:Space ):Void
    {
        switch( space )
        {
            case Space.WORLD: this.isWorldDirty = true;
            case Space.LOCAL: this.isLocalDirty = true;

            default:
                throw "model space not supported";
        }
    }

    // ************************************************************************ //
    // Position
    // ************************************************************************ //

    //
    public function getPosition( output:Vector2, ?space:Space ):Vector2
    {
        if( space == null )
            space = Space.LOCAL;

        switch( space )
        {
            case Space.WORLD:
            {
                if( this.isWorldDirty )
                    this.updateWorldMatrix();

                output.x = world.m31;
                output.y = world.m32;
            }

            case Space.LOCAL:
            {
                if( this.isLocalDirty )
                    this.updateLocalMatrix();

                output.x = local.m31;
                output.y = local.m32;
            }

            default:
                throw "model space not supported";
        }

        return output;
    }

    //
    public function setPosition( input:Vector2, ?space:Space ):Vector2
    {
        if( space == null )
            space = Space.LOCAL;

        //
        switch( space )
        {
            case Space.WORLD:
            {
                world.m31 = input.x;
                world.m32 = input.y;

                this.isWorldDirty = false;
                this.isLocalDirty = true;
            }

            case Space.LOCAL:
            {
                local.m31 = input.x;
                local.m32 = input.y;

                 this.isWorldDirty = true;
                 this.isLocalDirty = false;
            }

            default:
                throw "model space not supported";
        }

        this.notify();
        return input;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private inline function get_x( ):Float { return local.m31; }
    private inline function set_x( value:Float ):Float
    {
        if( !BasicMath.equals( local.m31, value ) ){
            this.isWorldDirty = true;
            this.notify();
        }

        return local.m31 = value;
    }

    //
    private inline function get_y( ):Float { return local.m32; }
    private inline function set_y( value:Float ):Float
    {
        if( !BasicMath.equals( local.m32, value ) ) {
            this.isWorldDirty = true;
            this.notify();
        }

        return local.m32 = value;
    }

    // ************************************************************************ //
    // Rotation
    // ************************************************************************ //

    //
    public function getRotation( output:Float, ?space:Space ):Float
    {
        throw new UnsupportedMethodException();
    }

    //
    public function setRotation( input:Float, ?space:Space ):Float
    {
        throw new UnsupportedMethodException();
    }

    // ************************************************************************ //
    // Scale
    // ************************************************************************ //

    //
    public function getScale( output:Vector2, ?space:Space ):Vector2
    {
        throw new UnsupportedMethodException();
    }

    //
    public function setScale( input:Vector2, ?space:Space ):Vector2
    {
        throw new UnsupportedMethodException();
    }

    // ************************************************************************ //
    // Matrix
    // ************************************************************************ //

    //
    public function getMatrix( output:Matrix3, ?space:Space ):Matrix3
    {
        if( space == null )
            space = Space.LOCAL;

        //
        switch(space)
        {
            case Space.WORLD:
            {
                if( this.isWorldDirty )
                    this.updateWorldMatrix();

                return world.clone( output );
            }

            case Space.LOCAL:
            {
                if( this.isLocalDirty )
                    this.updateLocalMatrix();

                return local.clone( output );
            }

            default:
                throw "model space not supported";
        }
    }

    //
    public function setMatrix( input:Matrix3, ?space:Space ):Matrix3
    {
        if( space == null )
            space = Space.LOCAL;

        //
        switch(space)
        {
            case Space.WORLD:
            {
                input.clone( world );

                this.isWorldDirty = false;
                this.isLocalDirty = true;
            }

            case Space.LOCAL:
            {
                input.clone( local );

                this.isWorldDirty = true;
                this.isLocalDirty = false;
            }

            default:
                throw "model space not supported";
        }

        this.notify();
        return input;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    /**
     * update local matrix from world matrix
     */
    private function updateLocalMatrix():Void
    {
        this.isLocalDirty = false;

        if( this.parent != null )
        {
            this.parent.transform.getMatrix( local, Space.WORLD )
                .inverse().multiply( world, true ); // inverse parent world * world = local
        }
        else
        {
            world.clone( local ); // world equals local
        }
    }

    /**
     * update world matrix from local matrix
     */
    private function updateWorldMatrix():Void
    {
        this.isWorldDirty = false;

        if( this.parent != null )
        {
            this.parent.transform.getMatrix( world, Space.WORLD )
                .multiply( local, true ); // parent world * local = world
        }
        else
        {
            local.clone( world ); // local equals world
        }
    }

}