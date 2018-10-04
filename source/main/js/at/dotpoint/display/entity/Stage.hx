package at.dotpoint.display.entity;

import at.dotpoint.datastructure.entity.GenericEntity;
import at.dotpoint.display.rendering.RenderViewport;
import js.html.DivElement;


/**
 *
 */
class Stage extends GenericEntity
{

    //
    public var viewport(default,null):RenderViewport;
    public var render(default,null):RenderBundle;

    //
    public function new( container:DivElement, numLayer:Int = 1 )
    {
        super();

        //
        this.viewport = new RenderViewport( container );
        this.render = new RenderBundle( viewport, numLayer );
        this.viewport.bundle = render;

        this.addComponent( viewport );
        this.addBundle( render );
    }

}
