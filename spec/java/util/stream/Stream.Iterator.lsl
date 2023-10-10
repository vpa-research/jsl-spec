libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtStream.java";

// imports

import java/util/stream/Stream;


// automata

automaton StreamIteratorAutomaton
(
    var parent: StreamLSL,
    var cursor: int
)
: StreamLSLIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       forEachRemaining,
       hasNext,
       next,
       remove,
    ];


    // methods

    fun *.hasNext (@target self: StreamLSLIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != StreamAutomaton(this.parent).length;
    }


    fun *.next (@target self: StreamLSLIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: array<Object> = StreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= StreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.cursor = i + 1;
        result = parentStorage[i];
    }


    fun *.remove (@target self: StreamLSLIterator): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    fun *.forEachRemaining (@target self: StreamLSLIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val size: int = StreamAutomaton(this.parent).length;

        if (i != size)
        {
            val pStorage: array<Object> = StreamAutomaton(this.parent).storage;

            action LOOP_WHILE(
                i < size,
                forEachRemaining_loop(userAction, pStorage, i)
            );

            this.cursor = i;
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, pStorage: array<Object>, i: int): void
    {
        val item: Object = pStorage[i];
        action CALL(userAction, [item]);

        i += 1;
    }
}