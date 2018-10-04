package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.event.ComponentType;
import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;

//
interface IEntity extends IComponentProvider
{
    public function onComponentSignal( origin:ComponentType, signal:SignalType, phase:SignalPropagation ):Void;

    public function getBundle( type:ComponentType ):IComponentBundle;
    public function getBundles():Array<IComponentBundle>;
}

//
interface IComponentProvider
{
    public function getComponent( type:ComponentType ):IComponent;
    public function getComponents():Array<IComponent>;
}
