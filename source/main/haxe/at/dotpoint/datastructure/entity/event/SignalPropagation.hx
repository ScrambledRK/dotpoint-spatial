package at.dotpoint.datastructure.entity.event;

//
enum SignalPropagation
{
    NONE;       // only entity
    CHILDREN;   // up
    PARENTS;    // down
}