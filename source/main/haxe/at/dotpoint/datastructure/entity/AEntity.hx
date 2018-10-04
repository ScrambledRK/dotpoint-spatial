package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;

/**
 *
 */
class AEntity
{

    //
    public var name:String;

    //
    public function new( ?name:String )
    {
        this.name = name;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    private function bindBundle( bundle:IComponentBundle, entity:IEntity ):Void
    {
        if( bundle.entity != entity )
            bundle.entity = entity;

        for( component in bundle.getComponents() )
            this.bindComponent( component, entity );
    }

    //
    private function bindComponent( component:IComponent, entity:IEntity ):Void
    {
        if( component.entity != entity )
            component.entity = entity;
    }

    // ------------------------------------------------------------------------ //
    // ------------------------------------------------------------------------ //

    //
    public function toString()
    {
        return name != null ? name : Type.getClassName( Type.getClass( this ) );
    }
}
