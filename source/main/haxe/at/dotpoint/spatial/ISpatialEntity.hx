package at.dotpoint.spatial;

import at.dotpoint.datastructure.entity.hierarchy.ITreeComponent;
import at.dotpoint.datastructure.entity.IEntity;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

//
interface ISpatialEntity<T:ISpatialEntity<T>> extends IEntity
{
    public var transform(default,null):ITransform;
    public var boundings(default,null):IBoundings;
    public var spatial(default,null):ITreeComponent<T>;
}

//
interface ISpatialObject extends ISpatialEntity<ISpatialObject> {
    //;
}
