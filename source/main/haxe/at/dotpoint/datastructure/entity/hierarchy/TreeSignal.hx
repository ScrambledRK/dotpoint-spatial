package at.dotpoint.datastructure.entity.hierarchy;

import at.dotpoint.datastructure.entity.event.SignalType;

//
class TreeSignal
{
    public static var CHANGED(default,never):SignalType = new SignalType("Tree.CHANGED");
}