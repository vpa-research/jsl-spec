libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$ValueIterator.java";

// imports

import java/lang/Object;
import java/util/HashMap;
import java/util/Iterator;
import java/util/function/Consumer;


// automata

automaton HashMapValueIteratorAutomaton
(
)
: HashMapValueIterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMapValueIterator,
    ];

    shift Initialized -> self by [
        // instance methods
        forEachRemaining,
        hasNext,
        next,
        remove,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.HashMapValueIterator (@target self: HashMapValueIterator, _this: HashMap)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.util.Iterator
    fun *.forEachRemaining (@target self: HashMapValueIterator, _action: Consumer): void
    {
        action TODO();
    }


    // within java.util.HashMap.HashIterator
    @final fun *.hasNext (@target self: HashMapValueIterator): boolean
    {
        action TODO();
    }


    @final fun *.next (@target self: HashMapValueIterator): Object
    {
        action TODO();
    }


    // within java.util.HashMap.HashIterator
    @final fun *.remove (@target self: HashMapValueIterator): void
    {
        action TODO();
    }

}