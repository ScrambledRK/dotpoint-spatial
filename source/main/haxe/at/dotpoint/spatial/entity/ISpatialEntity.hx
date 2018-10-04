package at.dotpoint.spatial.entity;

import at.dotpoint.datastructure.entity.IEntity;

//
interface ISpatialEntity extends IEntity
{
    public var spatial(default,null):ISpatialBundle;
}
