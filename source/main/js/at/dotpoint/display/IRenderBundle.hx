package at.dotpoint.display;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;

//
interface IRenderBundle extends IComponentBundle
{
    public function addChildAt( child:IDisplayBundle, layer:Int ):Void;
    public function removeChildAt( child:IDisplayBundle, layer:Int ):Void;
}

class RenderBundleType
{
    public static var CANVAS(default,never):ComponentType = new ComponentType("RenderBundle.CANVAS");
}