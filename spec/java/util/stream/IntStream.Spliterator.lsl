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
import java/util/function/IntConsumer;


// automata

automaton IntStreamSpliteratorAutomaton
(
    var parent: IntStreamLSL,
    var cursor: int
)
: IntStreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining (IntStreamLSLSpliterator, IntConsumer),
       forEachRemaining (IntStreamLSLSpliterator, Consumer),
       tryAdvance (IntStreamLSLSpliterator, IntConsumer),
       tryAdvance (IntStreamLSLSpliterator, Consumer),
       estimateSize,
       getComparator,
       getExactSizeIfKnown,
       hasCharacteristics,
    ];


    // methods

    fun *.characteristics (@target self: IntStreamLSLSpliterator): int
    {
        action TODO();
    }


    fun *.trySplit (@target self: IntStreamLSLSpliterator): Spliterator
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: IntStreamLSLSpliterator, _action: IntConsumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: IntStreamLSLSpliterator, _action: Consumer): void
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: IntStreamLSLSpliterator, _action: IntConsumer): boolean
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: IntStreamLSLSpliterator, _action: Consumer): boolean
    {
        action TODO();
    }


    fun *.estimateSize (@target self: IntStreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.getComparator (@target self: IntStreamLSLSpliterator): Comparator
    {
        action TODO();
    }


    fun *.getExactSizeIfKnown (@target self: IntStreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.hasCharacteristics (@target self: IntStreamLSLSpliterator, characteristics: int): boolean
    {
        action TODO();
    }
}