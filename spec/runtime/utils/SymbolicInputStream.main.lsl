libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "-";

// imports

import runtime/utils/SymbolicInputStream;


// automata

automaton SymbolicInputStreamAutomaton
(
    val maxSize: int = 10000,
    val supportMarks: boolean = false,
)
: SymbolicInputStream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        available,
        close,
        mark,
        markSupported,
        read (SymbolicInputStream),
        read (SymbolicInputStream, array<byte>),
        read (SymbolicInputStream, array<byte>, int, int),
        readAllBytes,
        readNBytes (SymbolicInputStream, array<byte>, int, int),
        readNBytes (SymbolicInputStream, int),
        reset,
        skip,
        transferTo,
    ];

    // internal variables

    @volatile var dataSize: int = -1;
    @volatile var data: array<byte> = null;
    @volatile var closed: boolean = false;
    @volatile var pos: int = 0;
    var markPos: int = -1;
    var markLimit: int = 0;


    // utilities

    // #todo: enable synchronization when parallel execution will be added
    /* @synchronized */ proc _initBuffer (): void
    {
        if (this.data == null)
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

            action ASSUME(this.data != null);
            action ASSUME(this.dataSize == action ARRAY_SIZE(this.data));
        }
    }

    @AutoInline @Phantom proc _checkBuffer (): void
    {
        if (this.data == null)
            _initBuffer(); // this should be a call because we do not have synchronization blocks yet

        action ASSUME(this.dataSize >= 0);
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
        // source: jdk.internal.util.Preconditions#checkFromIndexSize
        if ((length | fromIndex | size) < 0 || size > length - fromIndex)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", ["Range [%s, %<s + %s) out of bounds for length %s"]);
    }


    proc _updatePosition (delta: int): void
    {
        this.pos += delta;

        if (this.markPos != -1)
            if (this.pos >= this.markLimit)
                this.markPos = -1;
    }


    proc _moveDataTo (dest: array<byte>, offset: int, count: int): int
    {
        result = 0;

        val available: int = this.dataSize - this.pos;
        if (available != 0)
        {
            action ASSUME(available > 0);
            // transfer everything if there are not enougth bytes left
            if (available < count)
                count = available;

            action ARRAY_COPY(this.data, this.pos, dest, offset, count);
            _updatePosition(count);

            result = count;
        }
    }


    // constructors

    // static methods

    // methods

    @throws(["java.io.IOException"])
    fun *.available (@target self: SymbolicInputStream): int
    {
        _ensureOpen();
        result = this.dataSize - this.pos;
    }


    @throws(["java.io.IOException"])
    fun *.close (@target self: SymbolicInputStream): void
    {
        this.closed = true;
    }


    // within java.io.InputStream
    fun *.mark (@target self: SymbolicInputStream, readlimit: int): void
    {
        if (this.supportMarks)
        {
            this.markPos = this.pos;
            this.markLimit = readlimit;
        }
    }


    // within java.io.InputStream
    fun *.markSupported (@target self: SymbolicInputStream): boolean
    {
        result = this.supportMarks;
    }


    @throws(["java.io.IOException"])
    fun *.read (@target self: SymbolicInputStream): int
    {
        _ensureOpen();
        result = -1;
    }


    @throws(["java.io.IOException"])
    // within java.io.InputStream
    fun *.read (@target self: SymbolicInputStream, b: array<byte>): int
    {
        val len: int = action ARRAY_SIZE(b);
        if (len == 0)
        {
            result = 0;
        }
        else
        {
            action ASSUME(len > 0);
            _ensureOpen();
            result = _moveDataTo(b, 0, len);
        }
    }


    @throws(["java.io.IOException"])
    fun *.read (@target self: SymbolicInputStream, b: array<byte>, off: int, len: int): int
    {
        _checkFromIndexSize(off, len, action ARRAY_SIZE(b));
        if (len == 0)
        {
            result = 0;
        }
        else
        {
            _ensureOpen();
            result = _moveDataTo(b, off, len);
        }
    }


    @throws(["java.io.IOException"])
    fun *.readAllBytes (@target self: SymbolicInputStream): array<byte>
    {
        _ensureOpen();

        if (this.pos == 0)
        {
            result = this.data;
            _updatePosition(this.dataSize);
        }
        else if (this.pos == this.dataSize)
        {
            result = action ARRAY_NEW("byte", 0);
        }
        else
        {
            val len: int = this.dataSize - this.pos;
            action ASSUME(len > 0);

            result = action ARRAY_NEW("byte", len);
            _moveDataTo(result, 0, len);
        }
    }


    @throws(["java.io.IOException"])
    fun *.readNBytes (@target self: SymbolicInputStream, b: array<byte>, off: int, len: int): int
    {
        _checkFromIndexSize(off, len, action ARRAY_SIZE(b));
        _ensureOpen();

        if (len == 0)
            result = 0;
        else
            result = _moveDataTo(b, off, len);
    }


    @throws(["java.io.IOException"])
    fun *.readNBytes (@target self: SymbolicInputStream, len: int): array<byte>
    {
        if (len < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", ["len < 0"]);

        _ensureOpen();
        if (len == 0)
        {
            result = action ARRAY_NEW("byte", 0);
        }
        else
        {
            result = action ARRAY_NEW("byte", len);
            _moveDataTo(result, 0, len);
        }
    }


    @throws(["java.io.IOException"])
    // within java.io.InputStream
    fun *.reset (@target self: SymbolicInputStream): void
    {
        if (this.supportMarks)
        {
            _ensureOpen();
            if (this.markPos < 0)
                action THROW_NEW("java.io.IOException", ["Resetting to invalid mark"]);

            this.pos = this.markPos;
        }
        else
        {
            action THROW_NEW("java.io.IOException", ["mark/reset not supported"]);
        }
    }


    @throws(["java.io.IOException"])
    fun *.skip (@target self: SymbolicInputStream, n: long): long
    {
        _ensureOpen();
        result = 0L;
    }


    @throws(["java.io.IOException"])
    fun *.transferTo (@target self: SymbolicInputStream, out: OutputStream): long
    {
        if (out == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _ensureOpen();
        result = 0L;
    }

}
