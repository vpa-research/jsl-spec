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
import java/util/function/LongConsumer;


// automata

automaton LongStreamSpliteratorAutomaton
(
    var parent: LongStreamLSL,
    var cursor: int
)
: LongStreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining (LongStreamLSLSpliterator, LongConsumer),
       forEachRemaining (LongStreamLSLSpliterator, Consumer),
       tryAdvance (LongStreamLSLSpliterator, LongConsumer),
       tryAdvance (LongStreamLSLSpliterator, Consumer),
       estimateSize,
       getComparator,
       getExactSizeIfKnown,
       hasCharacteristics,
    ];


    // methods

    fun *.characteristics (@target self: LongStreamLSLSpliterator): int
    {
        action TODO();
    }


    fun *.trySplit (@target self: LongStreamLSLSpliterator): Spliterator
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: LongStreamLSLSpliterator, _action: LongConsumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: LongStreamLSLSpliterator, _action: Consumer): void
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: LongStreamLSLSpliterator, _action: LongConsumer): boolean
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: LongStreamLSLSpliterator, _action: Consumer): boolean
    {
        action TODO();
    }


    fun *.estimateSize (@target self: LongStreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.getComparator (@target self: LongStreamLSLSpliterator): Comparator
    {
        action TODO();
    }


    fun *.getExactSizeIfKnown (@target self: LongStreamLSLSpliterator): long
    {
        action TODO();
    }


    fun *.hasCharacteristics (@target self: LongStreamLSLSpliterator, characteristics: int): boolean
    {
        action TODO();
    }
}