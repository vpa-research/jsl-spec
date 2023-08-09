libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/HashMap.lsl";
import "java/util/function/_interfaces.lsl";

import "list-actions.lsl";


// local semantic types

@TypeMapping(typeVariable=true) typealias K = Object;
@TypeMapping(typeVariable=true) typealias V = Object;

@For(automaton="KeySpliteratorAutomaton", insteadOf="java.util.HashMap$KeySpliterator")
@Parameterized("K, V")
@extends("java.util.HashMap$HashMapSpliterator<K, V>")
@implements(["java.util.Spliterator<K>"])
@public @static @final type KeySpliterator
{
}


// automata

@Parameterized("K, V")
@public automaton KeySpliteratorAutomaton: KeySpliterator
(
)
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> this by [
        // read operations
        characteristics,
        trySplit,

        // write operations
        forEachRemaining,
        tryAdvance,
    ];


    // constructors

    constructor KeySpliterator (@target obj: KeySpliterator, @Parameterized("K, V") arg0: HashMap, arg1: int, arg2: int, arg3: int, arg4: int)
    {
        action TODO();
    }


    // utilities

    // static methods

    // methods

    fun characteristics (@target obj: KeySpliterator): int
    {
        action TODO();
    }


    fun forEachRemaining (@target obj: KeySpliterator, @Parameterized("? super K") arg0: Consumer): void
    {
        action TODO();
    }


    fun tryAdvance (@target obj: KeySpliterator, @Parameterized("? super K") arg0: Consumer): boolean
    {
        action TODO();
    }


    @ParameterizedResult("K, V")
    fun trySplit (@target obj: KeySpliterator): KeySpliterator
    {
        action TODO();
    }

}