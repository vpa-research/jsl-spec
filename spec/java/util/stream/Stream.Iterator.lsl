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
: StreamIterator
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


    // utilities

    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // methods

    fun *.hasNext (@target self: StreamIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != StreamAutomaton(this.parent).length;
    }


    fun *.next (@target self: StreamIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val parentStorage: list<Object> = StreamAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= StreamAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            _throwCME();

        this.cursor = i + 1;
        result = parentStorage[i];
    }


    fun *.remove (@target self: StreamIterator): void
    {
        action TODO();
    }


    fun *.forEachRemaining (@target self: StreamIterator, userAction: Consumer): void
    {
        action TODO();
    }
}