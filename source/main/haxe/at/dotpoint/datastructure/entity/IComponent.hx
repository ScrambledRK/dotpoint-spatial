package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IEntity.IComponentProvider;

//
interface IComponent extends IEntityProperty
{
    public function setBundle( bundle:IComponentBundle ):IComponentBundle;
    public function getBundle():IComponentBundle;
}

//
interface IComponentBundle extends IEntityProperty extends IComponentProvider
{
    public function onEntitySignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void;
}

//
interface IEntityProperty
{
    public var type(default,null):ComponentType;    // must be unique for each component
    public var entity(get,set):IEntity;             // component may only be part of one entity
}
