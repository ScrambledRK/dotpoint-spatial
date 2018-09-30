package at.dotpoint.datastructure.entity.hierarchy;

import at.dotpoint.exception.RuntimeException;

/**
 *
 */
class TreeContainer<T:IEntity> extends TreeObject<T>
{

    // ************************************************************************ //
    // constructor
    // ************************************************************************ //

    //
    public function new( entity:T )
    {
        super( entity );
    }

    // ************************************************************************ //
    // methods
    // ************************************************************************ //

    //
    override public function addChild( child:ITreeComponent<T> ):Void
    {
        if( this.children.indexOf( child ) != -1 )
            throw new RuntimeException("already child");

        if( child.parent != null )
            child.parent.removeChild( child );

        this.children.push( child );
        child.parent = this;
    }

    //
    override public function removeChild( child:ITreeComponent<T> ):Void
    {
        var index = this.children.indexOf( child );

        if( index == -1 )
            throw new RuntimeException("child not found");

        if( child.parent != cast this )
            throw new RuntimeException("not a parent of this child");

        this.children.splice( index, 1 );
        child.parent = null;
    }

}
