package at.dotpoint.display.entity;

import at.dotpoint.spatial.entity.ISpatialEntity;

//
interface IDisplayEntity extends ISpatialEntity
{
    public var display(default,null):IDisplayBundle;
}
