libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Spliterators.java";

// imports

import java/util/stream/Stream;
import java/util/function/Consumer;
import java/util/Spliterator;
import java/util/Comparator;


// automata

automaton StreamSpliteratorAutomaton
(
    var parent: StreamLSL,
    var cursor: int
)
: StreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining,
       tryAdvance,
       estimateSize,
       getComparator,
       getExactSizeIfKnown,
       hasCharacteristics,
    ];


    // methods

    fun *.characteristics (@target self: StreamLSLSpliterator): int
    {
        action TODO();
    }


    fun *.trySplit (@target self: StreamLSLSpliterator): Spliterator
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: StreamLSLSpliterator, _action: Consumer): void
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: StreamLSLSpliterator, _action: Consumer): boolean
    {
        action TODO();
    }


    fun *.estimateSize (@target self: StreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.getComparator (@target self: StreamLSLSpliterator): Comparator
    {
        action TODO();
    }


    fun *.getExactSizeIfKnown (@target self: StreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.hasCharacteristics (@target self: StreamLSLSpliterator, characteristics: int): boolean
    {
        action TODO();
    }
}