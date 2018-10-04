package at.dotpoint.display;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;
import at.dotpoint.display.renderable.IRenderable;
import at.dotpoint.spatial.bounds.IBoundings;
import at.dotpoint.spatial.transform.ITransform;

/**
 *
 */
interface IDisplayBundle extends IComponentBundle
{
    public var transform(default,null):ITransform;
    public var boundings(default,null):IBoundings;
    public var renderable(default,null):IRenderable;
}

//
class DisplayBundleType
{
    public static var SIMPLE(default,never):ComponentType = new ComponentType("DisplayBundle.Simple");
}