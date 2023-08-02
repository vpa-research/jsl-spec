libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/_interfaces.lsl";

import "list-actions.lsl";


// local semantic types

@TypeMapping(typeVariable=true) typealias E = Object;


// automata

@Parameterized("E")
@extends("java.util.AbstractSet<E>")
@implements(["java.util.Set<E>", "java.lang.Cloneable", "java.io.Serializable"])
@public automaton HashSet: int
(
    @static @final var serialVersionUID: long = -5024744406713321676;
)
{
    // states and shifts

    initstate Initialized;


    // constructors

    constructor HashSet ()
    {
        action TODO();
    }


    constructor HashSet (@Parameterized("? extends E") arg0: Collection)
    {
        action TODO();
    }


    constructor HashSet (arg0: int)
    {
        action TODO();
    }


    constructor HashSet (arg0: int, arg1: float)
    {
        action TODO();
    }


    constructor HashSet (arg0: int, arg1: float, arg2: boolean)
    {
        action TODO();
    }


    // utilities

    // static methods

    // methods

    fun add (arg0: E): boolean
    {
        action TODO();
    }


    fun clear (): void
    {
        action TODO();
    }


    fun clone (): Object
    {
        action TODO();
    }


    fun contains (arg0: Object): boolean
    {
        action TODO();
    }


    fun isEmpty (): boolean
    {
        action TODO();
    }


    @ParameterizedResult("E")
    fun iterator (): Iterator
    {
        action TODO();
    }


    fun remove (arg0: Object): boolean
    {
        action TODO();
    }


    fun size (): int
    {
        action TODO();
    }


    @ParameterizedResult("E")
    fun spliterator (): Spliterator
    {
        action TODO();
    }

}