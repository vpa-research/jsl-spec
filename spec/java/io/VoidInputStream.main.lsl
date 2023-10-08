libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/InputStream.java#L81";

// imports

import java/io/VoidInputStream;


// automata

automaton VoidInputStreamAutomaton
(
    @volatile var closed: boolean = false,
)
: VoidInputStream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        available,
        close,
        mark,
        markSupported,
        read (VoidInputStream),
        read (VoidInputStream, array<byte>),
        read (VoidInputStream, array<byte>, int, int),
        readAllBytes,
        readNBytes (VoidInputStream, array<byte>, int, int),
        readNBytes (VoidInputStream, int),
        reset,
        skip,
        transferTo,
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

    @throws(["java.io.IOException"])
    fun *.available (@target self: VoidInputStream): int
    {
        _ensureOpen();
        result = 0;
    }


    @throws(["java.io.IOException"])
    fun *.close (@target self: VoidInputStream): void
    {
        this.closed = true;
    }


    // within java.io.InputStream
    @synchronized fun *.mark (@target self: VoidInputStream, readlimit: int): void
    {
        // does nothing just like the original
    }


    // within java.io.InputStream
    fun *.markSupported (@target self: VoidInputStream): boolean
    {
        result = false;
    }


    @throws(["java.io.IOException"])
    fun *.read (@target self: VoidInputStream): int
    {
        _ensureOpen();
        result = -1;
    }


    @throws(["java.io.IOException"])
    // within java.io.InputStream
    fun *.read (@target self: VoidInputStream, b: array<byte>): int
    {
        if (action ARRAY_SIZE(b) == 0)
        {
            result = 0;
        }
        else
        {
            _ensureOpen();
            result = -1;
        }
    }


    @throws(["java.io.IOException"])
    fun *.read (@target self: VoidInputStream, b: array<byte>, off: int, len: int): int
    {
        _checkFromIndexSize(off, len, action ARRAY_SIZE(b));
        if (len == 0)
        {
            result = 0;
        }
        else
        {
            _ensureOpen();
            result = -1;
        }
    }


    @throws(["java.io.IOException"])
    fun *.readAllBytes (@target self: VoidInputStream): array<byte>
    {
        _ensureOpen();
        result = action ARRAY_NEW("byte", 0);
    }


    @throws(["java.io.IOException"])
    fun *.readNBytes (@target self: VoidInputStream, b: array<byte>, off: int, len: int): int
    {
        _checkFromIndexSize(off, len, action ARRAY_SIZE(b));
        _ensureOpen();
        result = 0;
    }


    @throws(["java.io.IOException"])
    fun *.readNBytes (@target self: VoidInputStream, len: int): array<byte>
    {
        if (len < 0)
        {
            action THROW_NEW("java.lang.IllegalArgumentException", ["len < 0"]);
        }
        else
        {
            _ensureOpen();
            result = action ARRAY_NEW("byte", 0);
        }
    }


    @throws(["java.io.IOException"])
    // within java.io.InputStream
    @synchronized fun *.reset (@target self: VoidInputStream): void
    {
        action THROW_NEW("java.io.IOException", ["mark/reset not supported"]);
    }


    @throws(["java.io.IOException"])
    fun *.skip (@target self: VoidInputStream, n: long): long
    {
        _ensureOpen();
        result = 0L;
    }


    @throws(["java.io.IOException"])
    fun *.transferTo (@target self: VoidInputStream, out: OutputStream): long
    {
        if (out == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _ensureOpen();
        result = 0L;
    }

}
