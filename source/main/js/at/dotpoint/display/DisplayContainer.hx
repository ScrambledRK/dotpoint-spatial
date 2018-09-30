package at.dotpoint.display;

import at.dotpoint.datastructure.entity.hierarchy.TreeContainer;
import at.dotpoint.display.renderable.ADisplayEntity;
import at.dotpoint.display.renderable.IDisplayEntity;
import at.dotpoint.display.renderable.NullRenderable;
import at.dotpoint.spatial.bounds.AABBContainer;
import at.dotpoint.spatial.transform.Transform;

//
class DisplayContainer extends ADisplayEntity<IDisplayObject> implements IDisplayObject
{
    public function new( ?name:String )
    {
        super( new NullRenderable(), name );

        this.spatial = new TreeContainer<IDisplayObject>( this );
        this.transform = new Transform(this);
        this.boundings = new AABBContainer(this);
        this.renderable.entity = this;
    }
}
