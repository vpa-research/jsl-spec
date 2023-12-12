libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$EntryIterator.java";

// imports

import java/lang/Object;
import java/util/HashMap;
import java/util/Iterator;
import java/util/function/Consumer;


// automata

automaton HashMap_EntryIteratorAutomaton
(
)
: HashMap_EntryIterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap_EntryIterator,
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

    @private constructor *.HashMap_EntryIterator (@target self: HashMap_EntryIterator, _this: HashMap)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.util.Iterator
    fun *.forEachRemaining (@target self: HashMap_EntryIterator, _action: Consumer): void
    {
        action TODO();
    }


    // within java.util.HashMap.HashIterator
    @final fun *.hasNext (@target self: HashMap_EntryIterator): boolean
    {
        action TODO();
    }


    @final fun *.next (@target self: HashMap_EntryIterator): Map_Entry
    {
        action TODO();
    }


    // within java.util.HashMap.HashIterator
    @final fun *.remove (@target self: HashMap_EntryIterator): void
    {
        action TODO();
    }

}