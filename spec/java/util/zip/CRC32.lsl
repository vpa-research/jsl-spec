libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/zip/CRC32.java";

// imports

import java/lang/Object;
import java/nio/ByteBuffer;
import java/util/zip/Checksum;


// local semantic types

@implements("java.util.zip.Checksum")
@public type CRC32
    is java.util.zip.CRC32
    for Object
{
}


// automata

automaton CRC32Automaton
(
)
: CRC32
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        CRC32,
    ];

    shift Initialized -> self by [
        // instance methods
        getValue,
        reset,
        update (CRC32, ByteBuffer),
        update (CRC32, array<byte>),
        update (CRC32, array<byte>, int, int),
        update (CRC32, int),
    ];

    // internal variables

    var crc: int = 0;


    // utilities

    proc _updateCheck(b: array<byte>, off: int, len: int): void
    {
        if (b == null)
        {
            action THROW_NEW("java.lang.NullPointerException", []);
        }
        var b_size: int = action ARRAY_SIZE(b);
        if (off < 0 || len < 0 || off > b_size - len)
        {
            action THROW_NEW("java.lang.ArrayIndexOutOfBoundsException", []);
        }
    }


    proc _updateByteBuffer(alder: int, addr: long, off: int, len: int): int
    {
        _updateByteBufferCheck(addr);
        result = action SYMBOLIC("int");
    }


    @Phantom proc _updateByteBufferCheck(addr: long)
        {
            if (addr == 0L)
            {
                action THROW_NEW("java.lang.NullPointerException", []);
            }
        }


    proc _updateBytes(crc: int, b: array<byte>, off: int, len: int): int
    {
        _updateBytesCheck(b, off, len);
        result = action SYMBOLIC("int");
    }


    @Phantom proc _updateBytesCheck (b: array<byte>, off: int, len: int): void
    {
        if (len != 0)
        {
            if (b != null)
            {
                var b_size: int = action ARRAY_SIZE(b);
                if (off < 0 || off >= b_size)
                {
                    action THROW_NEW("java.lang.ArrayIndexOutOfBoundsException", [off]);
                }
                var endIndex: int = off + len -1;
                if (endIndex <0 || endIndex >= b_size)
                {
                    action THROW_NEW("java.lang.ArrayIndexOutOfBoundsException", [endIndex]);
                }
            }
            else
            {
                action THROW_NEW("java.lang.NullPointerException", []);
            }
        }
    }

    // constructors

    constructor *.CRC32 (@target self: CRC32)
    {
        // original constructor is empty
    }


    // static methods

    // methods

    fun *.getValue (@target self: CRC32): long
    {
        result = (this.crc as long) & 4294967295L;
    }


    fun *.reset (@target self: CRC32): void
    {
        this.crc = 0;
    }


    fun *.update (@target self: CRC32, buffer: ByteBuffer): void
    {
        var pos: int = buffer.position();
        var limit: int = buffer.limit();
        if (pos > limit)
        {
            action THROW_NEW("java.lang.AssertionError", []);
        }
        var rem: int = limit - pos;
        if (rem > 0)
        {
            if (buffer is DirectBuffer)
            {
                var directBuffer: DirectBuffer = (buffer as DirectBuffer);
                var address: long = directBuffer.address();
                this.crc = _updateByteBuffer(this.crc, address, pos, rem);
            }
            else if (buffer.hasArray())
            {
                this.crc = _updateBytes(this.crc, buffer.array(), pos + buffer.arrayOffset(), rem);
            }
            else
            {
                var len: int = 4096;
                var b_rem: int = buffer.remaining();
                if (b_rem < len)
                {
                    len = b_rem;
                }
                var b: array<byte> = action ARRAY_NEW("byte", len);
                action LOOP_WHILE(
                    buffer.hasRemaining(),
                    _updateLoop(buffer, b)
                );
            }
            buffer.position(limit);
        }
    }


    @Phantom proc _updateLoop(buffer: ByteBuffer, b: array<byte>): void
    {
        var length: int = buffer.remaining();
        var b_size: int = action ARRAY_SIZE(b);
        if (b_size < length)
        {
            length = b_size;
        }
        buffer.get(b, 0, length);
        _updateCheck(b, 0, length);
        this.crc = _updateBytes(this.crc, b, 0, length);
    }


    // within java.util.zip.Checksum
    @default fun *.update (@target self: CRC32, b: array<byte>): void
    {
        var len: int = action ARRAY_SIZE(b);
        _updateCheck(b, 0, len);
        this.crc = _updateBytes(this.crc, b, 0, len);
    }


    fun *.update (@target self: CRC32, b: array<byte>, off: int, len: int): void
    {
        _updateCheck(b, off, len);
        this.crc = _updateBytes(this.crc, b, off, len);
    }


    fun *.update (@target self: CRC32, b: int): void
    {
        this.crc = action SYMBOLIC("int");
    }

}