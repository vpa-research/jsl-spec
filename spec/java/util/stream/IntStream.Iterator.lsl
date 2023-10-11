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
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != IntStreamAutomaton(this.parent).length;
    }


    fun *.next (@target self: IntStreamLSLIterator): Integer
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<int> = IntStreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= IntStreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
    }


    fun *.nextInt (@target self: IntStreamLSLIterator): int
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<int> = IntStreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= IntStreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
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