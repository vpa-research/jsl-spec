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
       nextLong,
       remove,
       forEachRemaining (LongStreamLSLIterator, Consumer),
       forEachRemaining (LongStreamLSLIterator, LongConsumer),
    ];


    // methods

    fun *.hasNext (@target self: LongStreamLSLIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != LongStreamAutomaton(this.parent).length;
    }


    fun *.next (@target self: LongStreamLSLIterator): Long
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<long> = LongStreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= LongStreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
    }


    fun *.nextLong (@target self: LongStreamLSLIterator): long
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<long> = LongStreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= LongStreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
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