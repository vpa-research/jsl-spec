libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtLongStream.java";

// imports

import java/util/stream/Stream;


// automata

automaton LongStreamIteratorAutomaton
(
    var parent: LongStreamLSL,
    var cursor: int
)
: LongStreamLSLIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       hasNext,
       next,
       nextInt,
       remove,
       forEachRemaining (LongStreamLSLIterator, Consumer),
       forEachRemaining (LongStreamLSLIterator, LongConsumer),
    ];


    // methods

    fun *.hasNext (@target self: LongStreamLSLIterator): boolean
    {
        action TODO();
    }


    fun *.next (@target self: LongStreamLSLIterator): Long
    {
        action TODO();
    }


    fun *.nextInt (@target self: LongStreamLSLIterator): long
    {
        action TODO();
    }


    fun *.remove (@target self: LongStreamLSLIterator): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    fun *.forEachRemaining (@target self: LongStreamLSLIterator, userAction: Consumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: LongStreamLSLIterator, userAction: LongConsumer): void
    {
        action TODO();
    }
}