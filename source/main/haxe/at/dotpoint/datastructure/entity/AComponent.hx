package at.dotpoint.datastructure.entity;

/**
 *
 */
class AComponent<T:IEntity> implements IComponent<T>
{

    //
    @:isVar public var entity(get,set):T;

    //
    public function new( entity:T )
    {
        this.entity = entity;
    }

    //
    private function get_entity( ):T return entity;
    private function set_entity( value:T ):T
    {
        return this.entity = value;
    }

}
