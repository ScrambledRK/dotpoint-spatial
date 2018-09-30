package at.dotpoint.display.rendering;

import at.dotpoint.datastructure.entity.event.SignalType;

/**
 *
 */
class ViewportSignal
{
    public static var TICK(default,never):SignalType = "Viewport.TICK";
    public static var RESIZE(default,never):SignalType = "Viewport.RESIZE";
}
