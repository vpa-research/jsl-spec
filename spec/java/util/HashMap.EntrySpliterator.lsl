libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$EntrySpliterator.java";

// imports

import java/lang/Object;
import java/util/Comparator;
import java/util/HashMap;
import java/util/Spliterator;
import java/util/function/Consumer;


// automata

automaton HashMap_EntrySpliteratorAutomaton
(
)
: HashMap_EntrySpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap_EntrySpliterator,
    ];

    shift Initialized -> self by [
        // instance methods
        characteristics,
        estimateSize,
        forEachRemaining,
        getComparator,
        getExactSizeIfKnown,
        hasCharacteristics,
        tryAdvance,
        trySplit,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.HashMap_EntrySpliterator (@target self: HashMap_EntrySpliterator, m: HashMap, origin: int, fence: int, est: int, expectedModCount: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.characteristics (@target self: HashMap_EntrySpliterator): int
    {
        action TODO();
    }


    // within java.util.HashMap.HashMapSpliterator
    @final fun *.estimateSize (@target self: HashMap_EntrySpliterator): long
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: HashMap_EntrySpliterator, _action: Consumer): void
    {
        action TODO();
    }


    // within java.util.Spliterator
    fun *.getComparator (@target self: HashMap_EntrySpliterator): Comparator
    {
        action TODO();
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: HashMap_EntrySpliterator): long
    {
        action TODO();
    }


    // within java.util.Spliterator
    fun *.hasCharacteristics (@target self: HashMap_EntrySpliterator, characteristics: int): boolean
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: HashMap_EntrySpliterator, _action: Consumer): boolean
    {
        action TODO();
    }


    fun *.trySplit (@target self: HashMap_EntrySpliterator): HashMap_EntrySpliterator
    {
        action TODO();
    }

}