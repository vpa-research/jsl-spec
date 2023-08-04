libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/HashMap.lsl";

import "list-actions.lsl";


// local semantic types

@TypeMapping(typeVariable=true) typealias K = Object;

@For(automaton="KeyIteratorAutomaton", insteadOf="java.util.HashMap$KeyIterator")
@extends("java.util.HashMap<K, V>$HashIterator")
@implements(["java.util.Iterator<K>"])
@public @final type KeyIterator
{
}


// automata

@public automaton KeyIteratorAutomaton: KeyIterator
(
)
{
    // states and shifts

    initstate Initialized;


    // constructors

    constructor `KeyIterator#KeyIterator` (@target obj: KeyIterator, arg0: HashMap)
    {
        action TODO();
    }


    // utilities

    // static methods

    // methods

    @final fun `KeyIterator#next` (@target obj: KeyIterator): K
    {
        action TODO();
    }

}