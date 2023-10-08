libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/OutputStream.java#L67";

// imports

import java/io/VoidOutputStream;


// automata

automaton VoidOutputStreamAutomaton
(
    @volatile var closed: boolean = false,
)
: VoidOutputStream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        close,
        flush,
        write (VoidOutputStream, array<byte>),
        write (VoidOutputStream, array<byte>, int, int),
        write (VoidOutputStream, int),
    ];

    // internal variables

    // utilities

    @throws(["java.io.IOException"]) // NOTE: useful for enhanced auto-inlining
    @AutoInline @Phantom proc _ensureOpen (): void
    {
        if (this.closed)
            action THROW_NEW("java.io.IOException", ["Stream closed"]);
    }


    proc _checkFromIndexSize (fromIndex: int, size: int, length: int): void
    {
        // source: jdk.internal.util.Preconditions#checkFromIndexSize
        if ((length | fromIndex | size) < 0 || size > length - fromIndex)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", ["Range [%s, %<s + %s) out of bounds for length %s"]);
    }


    // constructors

    // static methods

    // methods

    fun *.close (@target self: VoidOutputStream): void
    {
        this.closed = true;
    }


    @throws(["java.io.IOException"])
    // within java.io.OutputStream
    fun *.flush (@target self: VoidOutputStream): void
    {
        // does nothing just like the original
    }


    @throws(["java.io.IOException"])
    // within java.io.OutputStream
    fun *.write (@target self: VoidOutputStream, b: array<byte>): void
    {
        if (b == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _ensureOpen();
    }


    @throws(["java.io.IOException"])
    fun *.write (@target self: VoidOutputStream, b: array<byte>, off: int, len: int): void
    {
        _checkFromIndexSize(off, len, action ARRAY_SIZE(b));
        _ensureOpen();
    }


    @throws(["java.io.IOException"])
    fun *.write (@target self: VoidOutputStream, b: int): void
    {
        _ensureOpen();
    }

}
