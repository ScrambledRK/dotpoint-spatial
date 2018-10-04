package at.dotpoint.datastructure.entity.hierarchy;

import at.dotpoint.datastructure.entity.AComponent;
import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;
import at.dotpoint.exception.UnsupportedMethodException;

/**
 *
 */
class TreeObject<T:IComponentBundle> extends AComponent<T> implements ITreeComponent<T>
{

    @:isVar public var parent(get,set):ITreeComponent<T>;
    @:isVar public var children(get,set):Array<ITreeComponent<T>>;

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( type:ComponentType )
    {
        super( type );

        this.parent = null;
        this.children = new Array<ITreeComponent<T>>();
    }

    // ************************************************************************ //
    // getter / setter
    // ************************************************************************ //

    //
    public function getValue():T
    {
        return this.bundle;
    }

    //
    private function get_parent( ):ITreeComponent<T> return this.parent;
    private function set_parent( value:ITreeComponent<T> ):ITreeComponent<T>
    {
        if( value != this.parent ) {
            this.dispatch( TreeSignal.CHANGED, SignalPropagation.NONE );
        }

        return this.parent = value;
    }

    //
    private function get_children( ):Array<ITreeComponent<T>> return children;
    private function set_children( value:Array<ITreeComponent<T>> ):Array<ITreeComponent<T>>
    {
        return this.children = value;
    }

    // ************************************************************************ //
    // methods
    // ************************************************************************ //

    //
    public function addChild( child:ITreeComponent<T> ):Void {
        throw new UnsupportedMethodException("not allowed on leaf-node / tree-object");
    }

    //
    public function removeChild( child:ITreeComponent<T> ):Void {
        throw new UnsupportedMethodException("not allowed on leaf-node / tree-object");
    }

    //
    override public function dispatch( signal:SignalType, phase:SignalPropagation ):Void
    {
        switch( phase )
        {
            case SignalPropagation.NONE:
                this.entity.onComponentSignal( this.type, signal, phase );

            case SignalPropagation.CHILDREN:
            {
                for( child in this.children )
                {
                    child.entity.onComponentSignal( this.type, signal, phase );
                    child.dispatch( signal, phase );
                }
            }

            case SignalPropagation.PARENTS:
            {
                if( this.parent != null )
                {
                    this.parent.entity.onComponentSignal( this.type, signal, phase );
                    this.parent.dispatch( signal, phase );
                }
            }
        }
    }
}
