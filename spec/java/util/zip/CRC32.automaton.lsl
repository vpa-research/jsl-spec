libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/zip/CRC32.java";

// imports

import java/nio/ByteBuffer;
import java/util/zip/Checksum;
import sun/nio/ch/DirectBuffer;
import java/util/zip/CRC32;

// automata

automaton CRC32Automaton
(
)
: LSLCRC32
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
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
            action THROW_NEW("java.lang.NullPointerException", []);

        val b_size: int = action ARRAY_SIZE(b);
        if (off < 0 || len < 0 || off > b_size - len)
            action THROW_NEW("java.lang.ArrayIndexOutOfBoundsException", []);
    }


    proc _updateByteBuffer(addr: long): int
    {
        _updateByteBufferCheck(addr);
        result = action SYMBOLIC("int");
    }


    @AutoInline @Phantom proc _updateByteBufferCheck(addr: long): void
    {
        if (addr == 0L)
            action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _updateBytesCheck (b: array<byte>, off: int, len: int): void
    {
        if (len != 0)
        {
            if (b != null)
            {
                val b_size: int = action ARRAY_SIZE(b);
                action ASSUME(b_size >= 0);
                if (off < 0 || off >= b_size)
                    action THROW_NEW("java.lang.ArrayIndexOutOfBoundsException", [off]);

                val endIndex: int = off + len -1;
                if (endIndex <0 || endIndex >= b_size)
                    action THROW_NEW("java.lang.ArrayIndexOutOfBoundsException", [endIndex]);
            }
            else
            {
                action THROW_NEW("java.lang.NullPointerException", []);
            }
        }
    }

    // constructors

    constructor *.`<init>` (@target self: CRC32)
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
        val pos: int = action CALL_METHOD(buffer, "position", []);
        val limit: int = action CALL_METHOD(buffer, "limit", []);
        if (pos > limit)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos <= limit) in original CRC32

        val rem: int = limit - pos;
        if (rem > 0)
        {
            if (buffer is DirectBuffer)
            {
                val directBuffer: DirectBuffer = (buffer as DirectBuffer);
                val address: long = action CALL_METHOD(directBuffer, "address", []);
                this.crc = _updateByteBuffer(address);
            }
            else if (action CALL_METHOD(buffer, "hasArray", []))
            {
                val off: int = action CALL_METHOD(buffer, "arrayOffset", []) + pos;
                val bufferArray: array<byte> = action CALL_METHOD(buffer, "array", []);
                _updateBytesCheck(bufferArray, off, rem);
                this.crc = action SYMBOLIC("int");
            }
            else
            {
                var len: int = 4096;
                val b_rem: int = action CALL_METHOD(buffer, "remaining", []);
                if (b_rem < len)
                    len = b_rem;

                val b: array<byte> = action ARRAY_NEW("byte", len);
                val b_size: int = action ARRAY_SIZE(b);
                action ASSUME(b_size >= 0);
                action LOOP_WHILE(
                    action CALL_METHOD(buffer, "hasRemaining", []),
                    update_loop(buffer, b, b_size)
                );
                this.crc = action SYMBOLIC("int");
            }
            action CALL_METHOD(buffer, "position", [limit]);
        }
    }


    @Phantom proc update_loop(buffer: ByteBuffer, b: array<byte>, b_size: int): void
    {
        var length: int = action CALL_METHOD(buffer, "remaining", []);
        if (b_size < length)
            length = b_size;

        action CALL_METHOD(buffer, "get", [b, 0, length]);
        _updateCheck(b, 0, length);
        _updateBytesCheck(b, 0, length);
    }


    // within java.util.zip.Checksum
    fun *.update (@target self: CRC32, b: array<byte>): void
    {
        val len: int = action ARRAY_SIZE(b);
        action ASSUME(len >= 0);
        _updateCheck(b, 0, len);
        _updateBytesCheck(b, 0, len);
        this.crc = action SYMBOLIC("int");
    }


    fun *.update (@target self: CRC32, b: array<byte>, off: int, len: int): void
    {
        _updateCheck(b, off, len);
        _updateBytesCheck(b, off, len);
        this.crc = action SYMBOLIC("int");
    }


    fun *.update (@target self: CRC32, b: int): void
    {
        this.crc = action SYMBOLIC("int");
    }

}