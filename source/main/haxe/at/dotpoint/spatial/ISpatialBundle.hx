package at.dotpoint.spatial;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.hierarchy.ITreeComponent;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

//
interface ISpatialBundle extends IComponentBundle
{
    public var transform(default,null):ITransform;
    public var boundings(default,null):IBoundings;
    public var hierarchy(default,null):ITreeComponent<ISpatialBundle>;
}

//
class SpatialBundleType
{
    public static var OBJECT(default,never) = new ComponentType("SpatialBundle.Object");
    public static var CONTAINER(default,never) = new ComponentType("SpatialBundle.Container");
}