package at.dotpoint.datastructure.entity.hierarchy;

import at.dotpoint.datastructure.entity.AComponent;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.exception.UnsupportedMethodException;

/**
 *
 */
@:generic class TreeObject<T:IEntity> extends AComponent<T> implements ITreeComponent<T>
{

    @:isVar public var parent(get,set):ITreeComponent<T>;
    @:isVar public var children(get,set):Array<ITreeComponent<T>>;

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( entity:T )
    {
        super( entity );

        this.parent = null;
        this.children = new Array<ITreeComponent<T>>();
    }

    // ************************************************************************ //
    // getter / setter
    // ************************************************************************ //

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
    public function dispatch( signal:SignalType, type:SignalPropagation ):Void
    {
        switch( type )
        {
            case SignalPropagation.NONE:
                this.entity.onComponentSignal( signal, type );

            case SignalPropagation.CHILDREN:
            {
                for( child in this.children )
                {
                    child.entity.onComponentSignal( signal, type );
                    child.dispatch( signal, type );
                }
            }

            case SignalPropagation.PARENTS:
            {
                if( this.parent != null )
                {
                    this.parent.entity.onComponentSignal( signal, type );
                    this.parent.dispatch( signal, type );
                }
            }
        }
    }
}
