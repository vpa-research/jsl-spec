libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtIntStream.java";

// imports

import java/util/stream/Stream;


// automata

automaton IntStreamIteratorAutomaton
(
    var parent: IntStreamLSL,
    var cursor: int
)
: IntStreamLSLIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       hasNext,
       next,
       nextInt,
       remove,
       forEachRemaining (IntStreamLSLIterator, Consumer),
       forEachRemaining (IntStreamLSLIterator, IntConsumer),
    ];


    // methods

    fun *.hasNext (@target self: IntStreamLSLIterator): boolean
    {
        action TODO();
    }


    fun *.next (@target self: IntStreamLSLIterator): Integer
    {
        action TODO();
    }


    fun *.nextInt (@target self: IntStreamLSLIterator): int
    {
        action TODO();
    }


    fun *.remove (@target self: IntStreamLSLIterator): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    fun *.forEachRemaining (@target self: IntStreamLSLIterator, userAction: Consumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: IntStreamLSLIterator, userAction: IntConsumer): void
    {
        action TODO();
    }
}