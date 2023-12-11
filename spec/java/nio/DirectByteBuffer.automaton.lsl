libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectByteBuffer.java";

// imports
import java/io/FileDescriptor;
import java/lang/Object;
import java/lang/Runnable;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/nio/DoubleBuffer;
import java/nio/FloatBuffer;
import java/nio/IntBuffer;
import java/nio/LongBuffer;
import java/nio/MappedByteBuffer;
import java/nio/ShortBuffer;
import jdk/internal/ref/Cleaner;

// automata

automaton DirectByteBufferAutomaton
(
)
: LSLDirectByteBuffer
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        DirectByteBuffer (DirectByteBuffer, DirectBuffer, int, int, int, int, int),
        DirectByteBuffer (DirectByteBuffer, int),
        DirectByteBuffer (DirectByteBuffer, int, long, FileDescriptor, Runnable),
        DirectByteBuffer (DirectByteBuffer, long, int),
        DirectByteBuffer (DirectByteBuffer, long, int, Object),
    ];

    shift Initialized -> self by [
        // instance methods
        address,
        alignedSlice,
        alignmentOffset,
        array,
        arrayOffset,
        asCharBuffer,
        asDoubleBuffer,
        asFloatBuffer,
        asIntBuffer,
        asLongBuffer,
        asReadOnlyBuffer,
        asShortBuffer,
        attachment,
        capacity,
        cleaner,
        clear,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        force,
        get (DirectByteBuffer),
        get (DirectByteBuffer, array<byte>),
        get (DirectByteBuffer, array<byte>, int, int),
        get (DirectByteBuffer, int),
        getChar (DirectByteBuffer),
        getChar (DirectByteBuffer, int),
        getDouble (DirectByteBuffer),
        getDouble (DirectByteBuffer, int),
        getFloat (DirectByteBuffer),
        getFloat (DirectByteBuffer, int),
        getInt (DirectByteBuffer),
        getInt (DirectByteBuffer, int),
        getLong (DirectByteBuffer),
        getLong (DirectByteBuffer, int),
        getShort (DirectByteBuffer),
        getShort (DirectByteBuffer, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isLoaded,
        isReadOnly,
        limit (DirectByteBuffer),
        limit (DirectByteBuffer, int),
        load,
        mark,
        mismatch,
        order (DirectByteBuffer),
        order (DirectByteBuffer, ByteOrder),
        position (DirectByteBuffer),
        position (DirectByteBuffer, int),
        put (DirectByteBuffer, ByteBuffer),
        put (DirectByteBuffer, byte),
        put (DirectByteBuffer, array<byte>),
        put (DirectByteBuffer, array<byte>, int, int),
        put (DirectByteBuffer, int, byte),
        putChar (DirectByteBuffer, char),
        putChar (DirectByteBuffer, int, char),
        putDouble (DirectByteBuffer, double),
        putDouble (DirectByteBuffer, int, double),
        putFloat (DirectByteBuffer, float),
        putFloat (DirectByteBuffer, int, float),
        putInt (DirectByteBuffer, int),
        putInt (DirectByteBuffer, int, int),
        putLong (DirectByteBuffer, int, long),
        putLong (DirectByteBuffer, long),
        putShort (DirectByteBuffer, int, short),
        putShort (DirectByteBuffer, short),
        remaining,
        reset,
        rewind,
        slice (DirectByteBuffer),
        slice (DirectByteBuffer, int, int),
        toString,
    ];

    //internal variables
    var storage: array<byte> = action ARRAY_NEW("byte", 0);

    //MappedByteBuffer
    var fd: FileSescriptor = null;

    //DirectByteBuffer
    var att: Object = null;
    var cleaner: Cleaner = null;


    //Buffer variables
    var address: long = 0L;

    var mark: int = -1;
    var position: int = 0;
    var limit: int = 0;
    var capacity: int = 0;

    //ByteBuffer variables
     var hb: array<byte> = null;
     var offset: int = 0;
     var isReadOnly: boolean = false;

     var bigEndian: boolean = true;

    // utilities

    proc _checkBounds(off: int, len: int, size: int): void
    {
        if ((off | len | (off + len) | (size - (off + len))) < 0)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
    }

    proc _checkIndex(i: int): void
    {
        if ((i < 0) || (i >= limit))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
    }

    proc _checkIndex(i: int, nb: int): void
    {
        if ((i < 0) || (nb > limit - i))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
    }

    proc _get(i: int): byte
    {
        var ind: int = _nextGetIndex(i);
        result = this.storage[ind];
    }

    proc _get(dst: array<byte>, offset: int, length: int): void
    {
        _checkBounds(offset, length, dst.length);
        if (this.pos > this.limit)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos <= lim) in original
        var rem: int = _remaining();
        if (length > rem)
            action THROW_NEW("java.nio.BufferUnderflowException", []);
        var end: int = offset + length;
        var i: int = 0;
        var src_ind: int = 0;
        action FOR_LOOP(
            i, offset, end, +1,
            _get_loop(dst, i, src_ind)
        );
    }

    @Phantom proc _get_loop(dst: array<byte>, i: int, src_ind: int): void
    {
        src_ind = _nextGetIndex();
        dst[i] = this.storage[src_ind];
    }


    proc _limit(newLimit: int): void
    {
        if (newLimit > this.capacity | newLimit < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        this.limit = newLimit;
        if (this.position > this.limit)
            this.position = this.limit;
        if (this.mark > this.limit)
            this.mark = -1;
    }


    proc _position(newPosition: int): void
    {
        if (newPosition > this.limit | newPosition < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        this.position = newPosition;
        if (this.mark > this.position)
            this.mark = -1;
    }


    proc _remaining(): int
    {
        result = this.limit - this.position;
    }

    proc _alignmentOffset(index: int, unitSize: int): int
    {
        if (index < 0 || unitSize < 1 || (unitSize & (unitSize - 1)) != 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        if (unitSize > 8 && !this.isDirect)
            action THROW_NEW("java.lang.UnsupportedOperationException", []);
        result = ((this.address + index) % unitSize) as int;
    }

    proc _slice(pos: int, lim: int): int
    {
        if (pos < 0 || pos > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos >= 0)  and assert (pos <= lim) in original
        var rem: int = lim - pos;

        //#problem: create fields
        result = new DirectByteBufferAutomaton(self, -1, 0, rem, rem, pos);
    }

    proc _nextGetIndex(): int
    {
        if (this.position >= this.limit)
            action THROW_NEW("java.nio.BufferUnderflowException", []);
        this.position += 1;
        result = this.position;
    }

    proc _nextGetIndex(nb: int): int
    {
        if (this.limit - this.position < nb)
            action THROW_NEW("java.nio.BufferUnderflowException", []);
        var p: int = this.position;
        this.position += nb;
        result = p;
    }

    proc _nextPutIndex(): int
    {
        if (this.position >= this.limit)
            action THROW_NEW("java.nio.BufferOverflowException", []);
        this.position += 1;
        result = this.position;
    }

    proc _nextPutIndex(nb: int): int
    {
        if (this.limit - this.position < nb)
            action THROW_NEW("java.nio.BufferOverflowException", []);
        var p: int = this.position;
        this.position += nb;
        result = p;
    }

    proc _mismatch(that: ByteBuffer, that_pos: int, len: int): int
    {
        var i: int = 0;
        var returned: boolean = false;
        var this_pos = this.position;
        action LOOP_FOR(
            i, 0, len, +1,
            _mismatch_loop(i, this_pos, that, that_pos, returned)
        );
        if (!returned)
            i = -1;

        result = i;
    }

    @Phantom proc _mismatch_loop(i: int, this_pos: int, that: ByteBuffer, that_pos: int, returned: boolean): void
    {
        var that_got_loop: byte = action CALL_METHOD(that, "get", [that_pos + i]);
        var this_got_loop: byte = _get(this_pos + i);
        if (that_got_loop != this_got_loop)
        {
            returned = true;
            action LOOP_BREAK();
        }
    }

    //utilities for getChar

    proc _getChar(offset: long): char
    {
        var character: char = _getCharUnaligned(offset);
        result = _convEndian(character);
    }


    proc _getCharUnaligned(offset: long): char
    {
        result = _makeShort(this.storage[offset], this.storage[offset+1]) as char;
    }


    proc _convEndian(n: char): char
    {
        if (this.bigEndian == true) result = n;
        else result = action CALL_METHOD(null as Character, "reverseBytes", [n]);
    }

    //utilities for getDouble

    proc _getDouble(offset: long): double
    {
        var x: long = _getLongUnaligned(offset);
        var endian_x: long = _convEndian(x);
        result = _longBitsToDouble(endian_x);
    }


    proc _longBitsToDouble(bits: long): double
    {
        if (bits == 9218868437227405312L)
        {
            result = DOUBLE_POSITIVE_INFINITY;
        } else if (bits == 18442240474082181120L)
        {
            result = DOUBLE_NEGATIVE_INFINITY;
        } else if (bits >= 9218868437227405313L && bits =< 9223372036854775807L
                        || bits >= 18442240474082181121 && bits =< 18446744073709551615L)
        {
            result = DOUBLE_NAN;
        } else
        {
            var s: int = 0;
            if ((bits >> 63) == 0) s = 1;
            else s = -1;

            var e: int = ((bits >> 52) & 2047L) as int;
            var m: long = 0L;
            if (e == 0) m = (bits & 4503599627370495L) << 1;
            else m = (bits & 4503599627370495L) | 4503599627370496L;
            result = (s * m * 2 ^ (e - 1075)) as double;
        }
    }


    //utilities for getFloat

    proc _getFloat(offset: long): float
    {
        var x: int = _getIntUnaligned(offset);
        var endian_x: int = _convEndian(x);
        result = _intBitsToFloat(endian_x);
    }


    proc _intBitsToFloat(bits: int): float
    {
        if (bits == 2139095040)
        {
            result = FLOAT_POSITIVE_INFINITY;
        } else if (bits == 4286578688)
        {
            result = FLOAT_NEGATIVE_INFINITY;
        } else if (bits >= 2139095041 && bits =< 2147483647
                        || bits >= 4286578689 && bits =< 4294967295)
        {
            result = FLOAT_NAN;
        } else
        {
            var s: int = 0;
            if ((bits >> 31) == 0) s = 1;
            else s = -1;

            var e: int = (bits >> 23) & 255;
            var m: int = 0;
            if (e == 0) m = (bits & 8388607) << 1;
            else m = (bits & 8388607) | 8388608;
            result = (s * m * 2 ^ (e - 150)) as float;
        }
    }


    //utilities for getInt

    proc _getInt(offset: long): int
    {
        var x: int = _getIntUnaligned(offset);
        result = _convEndian(x);
    }

    proc _getIntUnaligned(offset: long): int
    {
        result = _makeInt(this.storage[offset],
                       this.storage[offset + 1],
                       this.storage[offset + 2],
                       this.storage[offset + 3]);
    }

    proc _convEndian(n: int): int
    {
        if (this.bigEndian == true) result = n;
        else result = action CALL_METHOD(null as Integer, "reverseBytes", [n]);
    }


    proc _makeInt(i0: byte, i1: byte, i2: byte, i3: byte): int
    {
        result = ((_toUnsignedInt(i0) << _pickPos(24, 0))
              | (_toUnsignedInt(i1) << _pickPos(24, 8))
              | (_toUnsignedInt(i2) << _pickPos(24, 16))
              | (_toUnsignedInt(i3) << _pickPos(24, 24)));
    }

    proc _toUnsignedInt(n: byte): int
    {
        result = n & 255;
    }

    //utilities for getLong

    proc _getLong(offset: long): long
    {
        var x: long = _getLongUnaligned(offset);
        result = _convEndian(x);
    }

    proc _getLongUnaligned(offset: long): long
    {
        result = _makeLong(this.storage[offset],
                         this.storage[offset + 1],
                         this.storage[offset + 2],
                         this.storage[offset + 3],
                         this.storage[offset + 4],
                         this.storage[offset + 5],
                         this.storage[offset + 6],
                         this.storage[offset + 7]);
    }


    proc _convEndian(n: long): long
    {
        if (this.bigEndian == true) result = n;
        else result = action CALL_METHOD(null as Long, "reverseBytes", [n]);
    }


    proc _makeLong(i0: byte, i1: byte, i2: byte, i3: byte, i4: byte, i5: byte, i6: byte, i7: byte): long
    {
        result = ((_toUnsignedLong(i0) << _pickPos(56, 0))
            | (_toUnsignedLong(i1) << _pickPos(56, 8))
            | (_toUnsignedLong(i2) << _pickPos(56, 16))
            | (_toUnsignedLong(i3) << _pickPos(56, 24))
            | (_toUnsignedLong(i4) << _pickPos(56, 32))
            | (_toUnsignedLong(i5) << _pickPos(56, 40))
            | (_toUnsignedLong(i6) << _pickPos(56, 48))
            | (_toUnsignedLong(i7) << _pickPos(56, 56)));
    }


    proc _toUnsignedLon(n: byte): long
    {
        result = n & 255L;
    }

    //utilities for getShort

    proc _getShort(offset: long): short
    {
        var x: short = _getShortUnaligned(offset);
        result = _convEndian(x);
    }

    proc _getShortUnaligned(offset: long): short
    {
        result = _makeShort(this.storage[offset], this.storage[offset+1]);
    }

    proc _convEndian(n: short): short
    {
        if (this.bigEndian == true) result = n;
        else result = action CALL_METHOD(null as Short, "reverseBytes", [n]);
    }

    proc _makeShort(i0: byte, i1: byte): short
    {
        result = ((_toUnsignedInt(i0) << _pickPos(8, 0))
            | (_toUnsignedInt(i1) << _pickPos(8, 8))) as short;
    }

    //utilities unsafe base

    proc _pickPos(top: int, pos: int): int
    {
        if (this.bigEndian == true) result = top - pos;
        else result = pos;
    }

    // constructors

    @private constructor *.DirectByteBuffer (@target self: DirectByteBuffer, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    @private constructor *.DirectByteBuffer (@target self: DirectByteBuffer, cap: int)
    {
        action TODO();
    }


    @protected constructor *.DirectByteBuffer (@target self: DirectByteBuffer, cap: int, addr: long, fd: FileDescriptor, unmapper: Runnable)
    {
        action TODO();
    }


    @private constructor *.DirectByteBuffer (@target self: DirectByteBuffer, addr: long, cap: int)
    {
        action TODO();
    }


    @private constructor *.DirectByteBuffer (@target self: DirectByteBuffer, addr: long, cap: int, ob: Object)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectByteBuffer): long
    {
        result = this.address;
    }


    // within java.nio.ByteBuffer
    @final fun *.alignedSlice (@target self: DirectByteBuffer, unitSize: int): ByteBuffer
    {
        var pos: int = this.position;
        var lim: int = this.limit;

        var pos_mod: int = _alignmentOffset(pos, unitSize);
        var lim_mod: int = _alignmentOffset(lim, unitSize);

        // Round up the position to align with unit size
        var aligned_pos: int = pos;
        if (pos_mod > 0)
            aligment_pos += unitSize - pos_mod;

        // Round down the limit to align with unit size
        var aligned_lim: int = lim - lim_mod;

        if (aligned_pos > lim || aligned_lim < pos) {
            aligned_lim = pos;
            aligned_pos = pos;
        }

        result = _slice(aligned_pos, aligned_lim);
    }


    // within java.nio.ByteBuffer
    @final fun *.alignmentOffset (@target self: DirectByteBuffer, index: int, unitSize: int): int
    {
        result = _alignmentOffset(index, unitSize);
    }


    // within java.nio.ByteBuffer
    @final fun *.array (@target self: DirectByteBuffer): array<byte>
    {
        if (this.hb == null)
            action THROW_NEW("java.lang.UnsupportedOperationException", []);
        if (this.isReadOnly == true)
            action THROW_NEW("java.nio.ReadOnlyBufferException", []);
        result = this.hb;
    }


    // within java.nio.ByteBuffer
    @final fun *.arrayOffset (@target self: DirectByteBuffer): int
    {
        if (this.hb == null)
            action THROW_NEW("java.lang.UnsupportedOperationException", []);
        if (this.isReadOnly == true)
            action THROW_NEW("java.nio.ReadOnlyBufferException", []);
        result = this.offset;
    }


    fun *.asCharBuffer (@target self: DirectByteBuffer): CharBuffer
    {
        action TODO();
    }


    fun *.asDoubleBuffer (@target self: DirectByteBuffer): DoubleBuffer
    {
        action TODO();
    }


    fun *.asFloatBuffer (@target self: DirectByteBuffer): FloatBuffer
    {
        action TODO();
    }


    fun *.asIntBuffer (@target self: DirectByteBuffer): IntBuffer
    {
        action TODO();
    }


    fun *.asLongBuffer (@target self: DirectByteBuffer): LongBuffer
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectByteBuffer): ByteBuffer
    {
        action TODO();
    }


    fun *.asShortBuffer (@target self: DirectByteBuffer): ShortBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectByteBuffer): Object
    {
        result = this.att;
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectByteBuffer): int
    {
        result = this.capacity;
    }


    fun *.cleaner (@target self: DirectByteBuffer): Cleaner
    {
        result = this.cleaner;
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectByteBuffer): Buffer
    {
        this.position = 0;
        this.limit = this.capacity;
        this.mark = -1;
        result = self;
    }

    fun *.compact (@target self: DirectByteBuffer): ByteBuffer
    {

        var pos: int = this.position;
        var lim: int = this.limit;
        if (pos > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos <= lim) in original

        var rem: int = _remaining();

        var new_storage: array<byte> = action ARRAY_NEW("byte", 0);

        var i: int = 0;
        var cur_pos: int = 0;
        action LOOP_FOR(
            i, pos, lim - 1, +1,
            _compact_loop(i, cur_pos)
        );

        _position(rem);
        //_limit just for reset limit? or we changed array size? (I didn't find a proove for last statement)
        _limit(this.capacity);
        this.mark = -1;
        result = self;
    }

    @Phantom proc _compact_loop(i: int, cur_pos: int): void
    {
        this.storage[cur_pos] = this.storage[i];
        cur_pos += 1;
    }


    // within java.nio.ByteBuffer
    fun *.compareTo (@target self: DirectByteBuffer, that: ByteBuffer): int
    {
        // #warning: optimization with vector operation when len>7  (in origin)
        var that_pos: int = action CALL_METHOD(that, "position", []);
        var that_rem: int = action CALL_METHOD(that, "remaining", []);

        var len: int = _remaining();
        if (that_rem < len)
            len = that_rem;

        var i: int = _mismatch(that, that_pos, len);

        if (i >= 0)
        {
            var this_index: int = this.position + i;
            var that_index: int = that_pos + i;
            var this_got: byte = _get(this_index);
            var that_got: byte = action CALL_METHOD(that, "get", [that_index]);
            result = this_got - that_got;
        }
        else {
            var rem: int = _remaining();
            var that_rem: int = action CALL_METHOD(that, "remaining", []);
            result = rem - that_rem;
        }
    }


    fun *.duplicate (@target self: DirectByteBuffer): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.equals (@target self: DirectByteBuffer, ob: Object): boolean
    {
        if (self == ob)
        {
            result = true;
        } else
        {
            if (!(ob is ByteBuffer))
            {
                result = false;
            } else
            {
                var that: ByteBuffer = ob as ByteBuffer;
                var this_rem: int = _remaining();
                var that_rem: int = action CALL_METHOD(that, "remaining", []);
                if (this_rem != that_rem)
                {
                    result = false;
                }
                else
                {
                    var that_pos: int = action CALL_METHOD(that, "position", []);
                    var i: int = _mismatch(that, that_pos, this_rem);
                    result = i < 0;
                }
            }
        }
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectByteBuffer): Buffer
    {
        this.limit = position;
        this.position = 0;
        this.mark = -1;
        result = self;
    }


    // within java.nio.MappedByteBuffer
    @final fun *.force (@target self: DirectByteBuffer): MappedByteBuffer
    {
        // #warning: write in file operation? how approximate it?
        result = self;
    }


    fun *.get (@target self: DirectByteBuffer): byte
    {
        var ind: int = _nextGetIndex();
        result = this.storage[ind];
    }


    // within java.nio.ByteBuffer
    fun *.get (@target self: DirectByteBuffer, dst: array<byte>): ByteBuffer
    {
        var len_dst: int = action ARRAY_SIZE(dst);
        _get(dst, 0, len_dst);
        result = self;
    }


    fun *.get (@target self: DirectByteBuffer, dst: array<byte>, offset: int, length: int): ByteBuffer
    {
        _get(dst, offset, length);
        result = self;
    }


    fun *.get (@target self: DirectByteBuffer, i: int): byte
    {
        result = _get(i);
    }


    fun *.getChar (@target self: DirectByteBuffer): char
    {
        var next_index = _nextGetIndex(2);
        result = _getChar(next_index as long);
    }


    fun *.getChar (@target self: DirectByteBuffer, i: int): char
    {
        _checkIndex(i, 2);
        result = _getChar(i as long);
    }


    fun *.getDouble (@target self: DirectByteBuffer): double
    {
        var next_index = _nextGetIndex(8);
        result = _getDouble(next_index as long);
    }


    fun *.getDouble (@target self: DirectByteBuffer, i: int): double
    {
        _checkIndex(i, 8);
        result = _getDouble(i as long);
    }


    fun *.getFloat (@target self: DirectByteBuffer): float
    {
        var next_index = _nextGetIndex(4);
        result = _getFloat(next_index as long);
    }


    fun *.getFloat (@target self: DirectByteBuffer, i: int): float
    {
        _checkIndex(i, 4);
        result = _getFloat(i as long);
    }


    fun *.getInt (@target self: DirectByteBuffer): int
    {
        var next_index = _nextGetIndex(4);
        result = _getInt(next_index as long);
    }


    fun *.getInt (@target self: DirectByteBuffer, i: int): int
    {
        _checkIndex(i, 4);
        result = _getInt(i as long);
    }


    fun *.getLong (@target self: DirectByteBuffer): long
    {
        var next_index = _nextGetIndex(8);
        result = _getLong(next_index as long);
    }


    fun *.getLong (@target self: DirectByteBuffer, i: int): long
    {
        _checkIndex(i, 8);
        result = _getLong(i as long);
    }


    fun *.getShort (@target self: DirectByteBuffer): short
    {
        var next_index = _nextGetIndex(2);
        result = _getShort(next_index as long);
    }


    fun *.getShort (@target self: DirectByteBuffer, i: int): short
    {
        _checkIndex(i, 2);
        result = _getShort(i as long);
    }


    // within java.nio.ByteBuffer
    @final fun *.hasArray (@target self: DirectByteBuffer): boolean
    {
        result = (this.hb != null) && !this.isReadOnly;
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectByteBuffer): boolean
    {
        result = this.position < this.limit;
    }


    // within java.nio.ByteBuffer
    fun *.hashCode (@target self: DirectByteBuffer): int
    {
        var h: int = 1;
        var p: int = this.position;

        var i: int = 0;
        var endLoop: int = p - 1;
        action LOOP_FOR(
            i, this.limit, endLoop, -1,
            _genHash_loop(h, i)
        );

        result = h;
    }

    @Phantom proc _genHash_loop(h: int, i: int): void
    {
        h = 31 * h + (_get(i) as int);
    }


    fun *.isDirect (@target self: DirectByteBuffer): boolean
    {
        result = true;
    }


    // within java.nio.MappedByteBuffer
    @final fun *.isLoaded (@target self: DirectByteBuffer): boolean
    {
        // #warning: operation with physical memory?
        result = action SYMBOLIC("boolean");
    }


    fun *.isReadOnly (@target self: DirectByteBuffer): boolean
    {
        result = false;
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectByteBuffer): int
    {
        result = this.limit;
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectByteBuffer, newLimit: int): Buffer
    {
        _limit(newLimit);
        result = self;
    }


    // within java.nio.MappedByteBuffer
    @final fun *.load (@target self: DirectByteBuffer): MappedByteBuffer
    {
        // #warning: operation with physical memory?
        result = self;
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectByteBuffer): Buffer
    {
        this.mark = this.position;
        result = self;
    }


    // within java.nio.ByteBuffer
    fun *.mismatch (@target self: DirectByteBuffer, that: ByteBuffer): int
    {
        var that_rem: int = action CALL_METHOD(that, "remaining", []);
        var len: int = _remaining();
        if (that_rem < len)
            len = that_rem;

        var r: int = _mismaatch(this.position, that, len);
        if (r == -1 && _remaining() != that.remaining()) result = len
        else result = r;
    }


    // within java.nio.ByteBuffer
    @final fun *.order (@target self: DirectByteBuffer): ByteOrder
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.order (@target self: DirectByteBuffer, bo: ByteOrder): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectByteBuffer): int
    {
        result = this.position;
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectByteBuffer, newPosition: int): Buffer
    {
        _position(newPosition);
        result = self;
    }


    fun *.put (@target self: DirectByteBuffer, src: ByteBuffer): ByteBuffer
    {
        if (src is DirectByteBuffer) {
            if (src == this)
                action THROW_NEW("java.lang.IllegalArgumentException", []);
            var sb: DirectByteBuffer = src as DirectByteBuffer;

            var spos: int = action CALL_METHOD(sb, "position", []);
            var slim: int = action CALL_METHOD(sb, "limit", []);
            if (spos > slim)
                action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (spos <= slim) in original

            var srem: int = slim - spos;

            var pos: int = this.position;
            var lim: int = this.limit;
            if (pos > lim)
                action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos <= lim) in original

            var rem: int = _remaining();
            if (srem > rem)
                action THROW_NEW("java.nio.BufferOverflowException", []);

            var src_array: array<byte> = action ARRAY_NEW("byte", srem);
            var src_i: int = 0;
            action CALL_METHOD(sb, "get", [src_array, spos, srem]);

            action LOOP_FOR(
                i, pos, slim, +1,
                _copy_loop(i, src_array, src_i)
            );

            _position(pos + srem);
        } else if (src.hb != null) {

            var spos: int = action CALL_METHOD(src, "position", []);
            var slim: int = action CALL_METHOD(src, "limit", []);
            if (spos > slim)
                action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (spos <= slim) in original

            var srem: int = slim - spos;

            _put(src.hb, src.offset + spos, srem);
            //action CALL_METHOD(src, "position", [spos + srem]);
            //src.position(spos + srem);

        } else {
            super.put(src);
        }
        result = self;
    }


    @Phantom proc _copy_loop(i: int, src_array: array<byte>, src_i: int): void
    {
        this.storage[i] = src_array[src_i];
        src_i += 1;
    }

    fun *.put (@target self: DirectByteBuffer, x: byte): ByteBuffer
    {
        var i = _nextPutIndex();
        this.storage[i] = x;
        result = this;
    }


    // within java.nio.ByteBuffer
    @final fun *.put (@target self: DirectByteBuffer, src: array<byte>): ByteBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectByteBuffer, src: array<byte>, offset: int, length: int): ByteBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectByteBuffer, i: int, x: byte): ByteBuffer
    {
        _checkIndex(i);
        this.storage[i] = x;
        result = this;
    }


    fun *.putChar (@target self: DirectByteBuffer, x: char): ByteBuffer
    {
        action TODO();
    }


    fun *.putChar (@target self: DirectByteBuffer, i: int, x: char): ByteBuffer
    {
        action TODO();
    }


    fun *.putDouble (@target self: DirectByteBuffer, x: double): ByteBuffer
    {
        action TODO();
    }


    fun *.putDouble (@target self: DirectByteBuffer, i: int, x: double): ByteBuffer
    {
        action TODO();
    }


    fun *.putFloat (@target self: DirectByteBuffer, x: float): ByteBuffer
    {
        action TODO();
    }


    fun *.putFloat (@target self: DirectByteBuffer, i: int, x: float): ByteBuffer
    {
        action TODO();
    }


    fun *.putInt (@target self: DirectByteBuffer, x: int): ByteBuffer
    {
        action TODO();
    }


    fun *.putInt (@target self: DirectByteBuffer, i: int, x: int): ByteBuffer
    {
        action TODO();
    }


    fun *.putLong (@target self: DirectByteBuffer, i: int, x: long): ByteBuffer
    {
        action TODO();
    }


    fun *.putLong (@target self: DirectByteBuffer, x: long): ByteBuffer
    {
        action TODO();
    }


    fun *.putShort (@target self: DirectByteBuffer, i: int, x: short): ByteBuffer
    {
        action TODO();
    }


    fun *.putShort (@target self: DirectByteBuffer, x: short): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectByteBuffer): int
    {
        result = _remaining();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectByteBuffer): Buffer
    {
        var m: int = mark;
        if (m < 0)
            action THROW_NEW("java.nio.InvalidMarkException", []);
        this.position = m;
        result = self;
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectByteBuffer): Buffer
    {
        this.position = 0;
        this.mark = -1;
        result = self;
    }


    fun *.slice (@target self: DirectByteBuffer): ByteBuffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectByteBuffer, pos: int, lim: int): ByteBuffer
    {
        result = _slice(pos, lim);
    }


    // within java.nio.ByteBuffer
    fun *.toString (@target self: DirectByteBuffer): String
    {
        action TODO();
    }

}