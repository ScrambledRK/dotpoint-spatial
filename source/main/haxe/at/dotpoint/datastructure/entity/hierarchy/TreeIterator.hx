package at.dotpoint.datastructure.entity.hierarchy;

import at.dotpoint.datastructure.iterator.DynamicTreeIterator;
import at.dotpoint.datastructure.iterator.IResetIterator;
import at.dotpoint.datastructure.iterator.TransformIterator;
import at.dotpoint.datastructure.graph.TreeTraversal;

/**
 *
 */
class TreeIterator<T:IEntity> implements IResetIterator<T>
{

    //
    private var tree:DynamicTreeIterator<ITreeComponent<T>>;
    private var transform:TransformIterator<ITreeComponent<T>,T>;

    // ************************************************************************ //
    // Constructor
    // ************************************************************************ //

    //
    public function new( node:ITreeComponent<T>, ?type:TreeTraversal )
    {
        this.tree = new DynamicTreeIterator<ITreeComponent<T>>( node, type, this.getChildren );
        this.transform = new TransformIterator( this.tree, this.toEntity );
    }

    //
    public function clone( ):IResetIterator<T>
    {
        return new TreeIterator( this.tree.item, this.tree.type );
    }

    // ************************************************************************ //
    // Methods
    // ************************************************************************ //

    //
    public function reset( ):Void
    {
        this.transform.reset();
    }

    //
    public function hasNext( ):Bool
    {
        return this.transform.hasNext();
    }

    //
    public function next( ):T
    {
        return this.transform.next();
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private function getChildren( node:ITreeComponent<T> ):Iterator<ITreeComponent<T>>
    {
        return node.children.iterator();
    }

    //
    private function toEntity( node:ITreeComponent<T> ):T
    {
        return node.entity;
    }
}
