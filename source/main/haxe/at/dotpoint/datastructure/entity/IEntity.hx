package at.dotpoint.datastructure.entity;

import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;

//
interface IEntity
{
    public function onComponentSignal( signal:SignalType, type:SignalPropagation ):Void;
}
