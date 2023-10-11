libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtDoubleStream.java";

// imports

import java/util/stream/Stream;


// automata

automaton DoubleStreamIteratorAutomaton
(
    var parent: DoubleStreamLSL,
    var cursor: int
)
: DoubleStreamLSLIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       hasNext,
       next,
       nextInt,
       remove,
       forEachRemaining (DoubleStreamLSLIterator, Consumer),
       forEachRemaining (DoubleStreamLSLIterator, DoubleConsumer),
    ];


    // methods

    fun *.hasNext (@target self: DoubleStreamLSLIterator): boolean
    {
        action TODO();
    }


    fun *.next (@target self: DoubleStreamLSLIterator): Double
    {
        action TODO();
    }


    fun *.nextInt (@target self: DoubleStreamLSLIterator): double
    {
        action TODO();
    }


    fun *.remove (@target self: DoubleStreamLSLIterator): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLIterator, userAction: Consumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLIterator, userAction: DoubleConsumer): void
    {
        action TODO();
    }
}