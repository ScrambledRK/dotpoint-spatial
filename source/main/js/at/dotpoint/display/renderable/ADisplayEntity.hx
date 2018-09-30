package at.dotpoint.display.renderable;

import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.display.renderable.IDisplayEntity.IDisplayObject;
import at.dotpoint.spatial.bounds.AABB;
import at.dotpoint.spatial.transform.Transform;
import at.dotpoint.datastructure.entity.hierarchy.TreeObject;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.spatial.ASpatialEntity;

/**
 *
 */
class ADisplayEntity<T:IDisplayEntity<T>> extends ASpatialEntity<T> implements IDisplayEntity<T>
{

    //
    public var renderable(default,null):IRenderable;

    //
    public function new( renderable:IRenderable, ?name:String )
    {
        super( name );
        this.renderable = renderable;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    override public function onComponentSignal( signal:SignalType, type:SignalPropagation ):Void
    {
        switch( signal )
        {
            case RenderableSignal.DEPTH_CHANGED:
                this.onRenderableChanged( type );

            default:
                super.onComponentSignal( signal, type );
        }
    }

    //
    private function onRenderableChanged( signal:SignalPropagation ):Void
    {
        if( signal == SignalPropagation.NONE )
            this.spatial.dispatch( RenderableSignal.DEPTH_CHANGED, SignalPropagation.PARENTS );
    }

    //
    override private function onTransformChanged( signal:SignalPropagation ):Void
    {
        super.onTransformChanged( signal );

        //
        switch( signal )
        {
            default:
                this.renderable.invalidate();   // may be called more than necessary (RenderContainer)
        }
    }

    //
    override private function onHierarchyChanged( signal:SignalPropagation ):Void
    {
        super.onHierarchyChanged( signal );

        //
        switch( signal )
        {
            case SignalPropagation.NONE:        // this got added/removed
            {
                this.renderable.invalidate();
            }

            case SignalPropagation.CHILDREN:    // parent got added/removed
            {
                this.renderable.invalidate();
            }

            case SignalPropagation.PARENTS:     // child got added/removed
            {
                //;
            }
        }
    }
}

/**
 *
 */
class ADisplayObject extends ADisplayEntity<IDisplayObject> implements IDisplayObject
{
    //
    public function new( renderable:IRenderable, ?name:String )
    {
        super( renderable, name );

        this.spatial = new TreeObject<IDisplayObject>( this );
        this.transform = new Transform( this );
        this.boundings = new AABB( this );
        this.renderable.entity = this;
    }
}
