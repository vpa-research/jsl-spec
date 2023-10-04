libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Stream.java";

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


    // local variables

    var lastRet: int = -1;


    // utilities

    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


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

        // iterrator validity check
        if (i >= action ARRAY_SIZE(parentStorage))
            _throwCME();

        this.cursor = i + 1;
        this.lastRet = i;
        result = parentStorage[i];
    }


    fun *.remove (@target self: StreamLSLIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        val pStorage: array<Object> = StreamAutomaton(this.parent).storage;
        val pLength: int = StreamAutomaton(this.parent).length;

        if (this.lastRet >= action ARRAY_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            val newLength: int = pLength - 1;
            val newStorage: array<Object> = action ARRAY_NEW("java.lang.Object", newLength);

            // That's right ?
            action ARRAY_COPY(pStorage, 0, newStorage, 0, this.lastRet);
            action ARRAY_COPY(pStorage, this.lastRet + 1, newStorage, this.lastRet, pLength - this.lastRet - 1);

            StreamAutomaton(this.parent).storage = pStorage;
            StreamAutomaton(this.parent).length = newLength;
        }

        this.cursor = this.lastRet;
        this.lastRet = -1;
    }


    fun *.forEachRemaining (@target self: StreamLSLIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val size: int = StreamAutomaton(this.parent).length;

        if (i < size)
        {
            val pStorage: array<Object> = StreamAutomaton(this.parent).storage;

            if (i >= action ARRAY_SIZE(pStorage))
                _throwCME();

            action LOOP_WHILE(
                i < size,
                forEachRemaining_loop(userAction, pStorage, i)
            );

            this.cursor = i;
            this.lastRet = i - 1;
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, pStorage: array<Object>, i: int): void
    {
        val item: Object = pStorage[i];
        action CALL(userAction, [item]);

        i += 1;
    }
}