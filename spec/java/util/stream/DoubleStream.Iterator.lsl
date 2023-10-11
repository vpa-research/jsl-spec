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
       nextDouble,
       remove,
       forEachRemaining (DoubleStreamLSLIterator, Consumer),
       forEachRemaining (DoubleStreamLSLIterator, DoubleConsumer),
    ];


    // methods

    fun *.hasNext (@target self: DoubleStreamLSLIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != DoubleStreamAutomaton(this.parent).length;
    }


    fun *.next (@target self: DoubleStreamLSLIterator): Double
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<double> = DoubleStreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= DoubleStreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
    }


    fun *.nextDouble (@target self: DoubleStreamLSLIterator): double
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<double> = DoubleStreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= DoubleStreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
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