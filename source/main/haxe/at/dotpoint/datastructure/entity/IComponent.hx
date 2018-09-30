package at.dotpoint.datastructure.entity;

/**
 * 
 */
interface IComponent<T:IEntity>
{
    public var entity(get,set):T;
}
