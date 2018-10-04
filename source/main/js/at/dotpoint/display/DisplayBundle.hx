package at.dotpoint.display;

import at.dotpoint.datastructure.entity.AComponentBundle;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.hierarchy.TreeSignal;
import at.dotpoint.datastructure.entity.IComponent;
import at.dotpoint.display.renderable.IRenderable;
import at.dotpoint.display.rendering.RenderLayer;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

/**
 *
 */
class DisplayBundle extends AComponentBundle implements IDisplayBundle
{

    public var transform(default,null):ITransform;
    public var boundings(default,null):IBoundings;
    public var renderable(default,null):IRenderable;

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( type:ComponentType, transform:ITransform, boundings:IBoundings,
                         renderable:IRenderable )
    {
        super( type );

        this.transform = transform;
        this.boundings = boundings;
        this.renderable = renderable;
    }

    // ************************************************************************ //
    // ComponentManager
    // ************************************************************************ //

    //
    public function getComponent( type:ComponentType ):IComponent
    {
        if( this.transform.type == type )
            return this.transform;

        if( this.boundings.type == type  )
            return this.boundings;

        if( this.renderable.type == type )
            return this.renderable;

        return null;
    }

    //
    public function getComponents( ):Array<IComponent>
    {
        return [this.transform, this.boundings, this.renderable];
    }

    // ************************************************************************ //
    // Events
    // ************************************************************************ //

    //
    public function onEntitySignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void
    {
        switch( signal )
        {
            case TransformSignal.CHANGED:                   // local and/or world matrix changed
            {
                if( phase != SignalPropagation.PARENTS )    // this or parent changed
                    this.renderable.invalidate();
            }

            case TreeSignal.CHANGED:                        // got removed from or added to a container
            {
                if( phase != SignalPropagation.PARENTS )    // this or parent changed
                    this.renderable.invalidate();
            }
        }
    }

    // ************************************************************************ //
    // Helper
    // ************************************************************************ //

    //
    public function clear( layer:RenderLayer ):Void
    {
        this.renderable.clear( layer );
    }

    //
    public function render( layer:RenderLayer ):Void
    {
        this.renderable.render( layer );
    }

}
