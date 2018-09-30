package at.dotpoint.datastructure.entity.event;

/**
 * 
 */
abstract SignalType(String) from String to String
{
    public function new( value:String )
    {
        this = value;
    }
}
