package at.dotpoint.display.renderable;

import at.dotpoint.spatial.ISpatialEntity;

//
interface IDisplayEntity<T:IDisplayEntity<T>> extends ISpatialEntity<T>
{
    public var renderable(default,null):IRenderable;
}

//
interface IDisplayObject extends IDisplayEntity<IDisplayObject> {
    //;
}

//
typedef TDisplayObject = IDisplayEntity<Dynamic>;