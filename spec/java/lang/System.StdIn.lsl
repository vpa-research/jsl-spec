libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/InputStream.java#L81";

// imports

import java/lang/System;


// automata

automaton System_InputStreamAutomaton
(
    val maxSize: int = 10000,
)
: System_InputStream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        available,
        close,
        mark,
        markSupported,
        read (System_InputStream),
        read (System_InputStream, array<byte>),
        read (System_InputStream, array<byte>, int, int),
        readAllBytes,
        readNBytes (System_InputStream, array<byte>, int, int),
        readNBytes (System_InputStream, int),
        reset,
        skip,
        transferTo,
    ];

    // internal variables

    @volatile var dataSize: int = -1;
    @volatile var data: array<byte> = null;
    @volatile var closed: boolean = false;


    // utilities

    @AutoInline @Phantom proc _initBuffer (): void
    {
        action ASSUME(this.maxSize > 0);

        // choose a new size
        val newSize: int = action SYMBOLIC("int");
        action ASSUME(0       <= newSize);
        action ASSUME(newSize <  this.maxSize);
        this.dataSize = newSize;

        // "allocating" memory and "filling" it up with fake data
        if (newSize == 0)
            this.data = action ARRAY_NEW("byte", 0);
        else
            this.data = action SYMBOLIC_ARRAY("byte", newSize);
    }

    @AutoInline @Phantom proc _checkBuffer (): void
    {
        if (this.data == null)
            _initBuffer();
    }


    @throws(["java.io.IOException"]) // NOTE: useful for enhanced auto-inlining
    @AutoInline @Phantom proc _ensureOpen (): void
    {
        if (this.closed)
            action THROW_NEW("java.io.IOException", ["Stream closed"]);

        _checkBuffer();
    }


    proc _checkFromIndexSize (fromIndex: int, size: int, length: int): void
    {
        if ((length | fromIndex | size) < 0 || size > length - fromIndex)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", ["Range [%s, %<s + %s) out of bounds for length %s"]);
    }


    // constructors

    // static methods

    // methods

    @throws(["java.io.IOException"])
    fun *.available (@target self: System_InputStream): int
    {
        _ensureOpen();
        result = 0;
    }


    @throws(["java.io.IOException"])
    fun *.close (@target self: System_InputStream): void
    {
        this.closed = true;
    }


    // within java.io.InputStream
    @synchronized fun *.mark (@target self: System_InputStream, readlimit: int): void
    {
        // does nothing just like the original
    }


    // within java.io.InputStream
    fun *.markSupported (@target self: System_InputStream): boolean
    {
        result = false;
    }


    @throws(["java.io.IOException"])
    fun *.read (@target self: System_InputStream): int
    {
        _ensureOpen();
        result = -1;
    }


    @throws(["java.io.IOException"])
    // within java.io.InputStream
    fun *.read (@target self: System_InputStream, b: array<byte>): int
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
    fun *.read (@target self: System_InputStream, b: array<byte>, off: int, len: int): int
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
    fun *.readAllBytes (@target self: System_InputStream): array<byte>
    {
        _ensureOpen();
        result = action ARRAY_NEW("byte", 0);
    }


    @throws(["java.io.IOException"])
    fun *.readNBytes (@target self: System_InputStream, b: array<byte>, off: int, len: int): int
    {
        _checkFromIndexSize(off, len, action ARRAY_SIZE(b));
        _ensureOpen();
        result = 0;
    }


    @throws(["java.io.IOException"])
    fun *.readNBytes (@target self: System_InputStream, len: int): array<byte>
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
    @synchronized fun *.reset (@target self: System_InputStream): void
    {
        action THROW_NEW("java.io.IOException", ["mark/reset not supported"]);
    }


    @throws(["java.io.IOException"])
    fun *.skip (@target self: System_InputStream, n: long): long
    {
        _ensureOpen();
        result = 0L;
    }


    @throws(["java.io.IOException"])
    fun *.transferTo (@target self: System_InputStream, out: OutputStream): long
    {
        if (out == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _ensureOpen();
        result = 0L;
    }

}
