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
import java/util/function/DoubleConsumer;


// automata

automaton DoubleStreamSpliteratorAutomaton
(
    var parent: DoubleStreamLSL,
    var cursor: int
)
: DoubleStreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining (DoubleStreamLSLSpliterator, DoubleConsumer),
       forEachRemaining (DoubleStreamLSLSpliterator, Consumer),
       tryAdvance (DoubleStreamLSLSpliterator, DoubleConsumer),
       tryAdvance (DoubleStreamLSLSpliterator, Consumer),
       estimateSize,
       getComparator,
       getExactSizeIfKnown,
       hasCharacteristics,
    ];


    // methods

    fun *.characteristics (@target self: DoubleStreamLSLSpliterator): int
    {
        action TODO();
    }


    fun *.trySplit (@target self: DoubleStreamLSLSpliterator): Spliterator
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLSpliterator, _action: DoubleConsumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLSpliterator, _action: Consumer): void
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: DoubleStreamLSLSpliterator, _action: DoubleConsumer): boolean
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: DoubleStreamLSLSpliterator, _action: Consumer): boolean
    {
        action TODO();
    }


    fun *.estimateSize (@target self: DoubleStreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.getComparator (@target self: DoubleStreamLSLSpliterator): Comparator
    {
        action TODO();
    }


    fun *.getExactSizeIfKnown (@target self: DoubleStreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.hasCharacteristics (@target self: DoubleStreamLSLSpliterator, characteristics: int): boolean
    {
        action TODO();
    }
}