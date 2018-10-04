package at.dotpoint.datastructure.entity.event;

/**
 * 
 */
abstract ComponentType(Int) to Int
{

    //
    public function new( hash:String )
    {
        this = HashId.generate();

        #if debug
            HashId.register( "ComponentType", hash, this );
        #end
    }

    //
    public function toString():String
    {
        #if debug
            return HashId.trace( this );
        #else
            return Std.string( this );
        #end
    }

}
