libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$ValueSpliterator.java";

// imports

import java/lang/Object;
import java/util/Comparator;
import java/util/HashMap;
import java/util/Spliterator;
import java/util/function/Consumer;


// automata

automaton HashMapValueSpliteratorAutomaton
(
)
: HashMapValueSpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMapValueSpliterator,
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

    @private constructor *.HashMapValueSpliterator (@target self: HashMapValueSpliterator, m: HashMap, origin: int, fence: int, est: int, expectedModCount: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.characteristics (@target self: HashMapValueSpliterator): int
    {
        action TODO();
    }


    // within java.util.HashMap.HashMapSpliterator
    @final fun *.estimateSize (@target self: HashMapValueSpliterator): long
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: HashMapValueSpliterator, _action: Consumer): void
    {
        action TODO();
    }


    // within java.util.Spliterator
    fun *.getComparator (@target self: HashMapValueSpliterator): Comparator
    {
        action TODO();
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: HashMapValueSpliterator): long
    {
        action TODO();
    }


    // within java.util.Spliterator
    fun *.hasCharacteristics (@target self: HashMapValueSpliterator, characteristics: int): boolean
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: HashMapValueSpliterator, _action: Consumer): boolean
    {
        action TODO();
    }


    fun *.trySplit (@target self: HashMapValueSpliterator): HashMapValueSpliterator
    {
        action TODO();
    }

}