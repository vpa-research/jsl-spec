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


    // As I understood this forEachRemaining's will be equal - this is true ?
    fun *.forEachRemaining (@target self: DoubleStreamLSLIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val size: int = DoubleStreamAutomaton(this.parent).length;

        if (i != size)
        {
            val pStorage: array<double> = DoubleStreamAutomaton(this.parent).storage;

            action LOOP_WHILE(
                i < size,
                forEachRemaining_loop(userAction, pStorage, i)
            );

            this.cursor = i;
        }
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLIterator, userAction: DoubleConsumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val size: int = DoubleStreamAutomaton(this.parent).length;

        if (i != size)
        {
            val pStorage: array<double> = DoubleStreamAutomaton(this.parent).storage;

            action LOOP_WHILE(
                i < size,
                forEachRemaining_loop(userAction, pStorage, i)
            );

            this.cursor = i;
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: DoubleConsumer, pStorage: array<double>, i: int): void
    {
        val item: double = pStorage[i];
        action CALL(userAction, [item]);

        i += 1;
    }
}