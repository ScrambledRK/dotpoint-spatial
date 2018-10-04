package at.dotpoint.datastructure.entity.hierarchy;

import at.dotpoint.datastructure.entity.event.SignalPropagation;
import at.dotpoint.datastructure.entity.event.SignalType;
import at.dotpoint.datastructure.entity.IComponent.IComponentBundle;

//
interface ITreeComponent<T:IComponentBundle> extends IComponent extends ITreeDispatcher
{
    public function getValue():T;

    public var parent(get,set):ITreeComponent<T>;
    public var children(get,set):Array<ITreeComponent<T>>;

    public function addChild( child:ITreeComponent<T> ):Void;
    public function removeChild( child:ITreeComponent<T> ):Void;
}

//
interface ITreeDispatcher
{
    public function dispatch( signal:SignalType, type:SignalPropagation ):Void;
}