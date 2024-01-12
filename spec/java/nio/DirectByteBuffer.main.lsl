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
import java/lang/Short;
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
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectByteBuffer
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (DirectByteBuffer, DirectBuffer, int, int, int, int, int),
        `<init>` (DirectByteBuffer, int),
        `<init>` (DirectByteBuffer, int, long, FileDescriptor, Runnable),
        `<init>` (DirectByteBuffer, long, int),
        `<init>` (DirectByteBuffer, long, int, Object),
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
    var storage: array<byte> = null;

    //MappedByteBuffer
    var fd: FileDescriptor = null;

    //DirectByteBuffer
    var cleaner: Cleaner = null;

    //Buffer variables
    var address: long = 0L;


    //ByteBuffer variables
    var hb: array<byte> = null;
    var isReadOnly: boolean = false;

    var bigEndian: boolean = true;
    var nativeByteOrder: boolean = false;

    // utilities

    proc _checkBounds(off: int, len: int, size: int): void
    {
        if ((off | len | (off + len) | (size - (off + len))) < 0)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
    }


    proc _checkIndex(i: int): void
    {
        if ((i < 0) || (i >= this.limit))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
    }


    proc _checkIndex(i: int, nb: int): void
    {
        if ((i < 0) || (nb > this.limit - i))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
    }


    @KeepVisible proc _offset(): int
    {
        result = this.offset;
    }


    @KeepVisible proc _hb(): int
    {
        result = this.hb;
    }


    proc _get(i: int): byte
    {
        var ind: int = _nextGetIndex(i);
        result = this.storage[ind];
    }


    proc _get(dst: array<byte>, offset: int, length: int): void
    {
        var dst_length: int = action ARRAY_SIZE(dst);
        _checkBounds(offset, length, dst_length);
        if (this.position > this.limit)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos <= lim) in original
        var rem: int = _remaining();
        if (length > rem)
            action THROW_NEW("java.nio.BufferUnderflowException", []);
        var end: int = offset + length;
        var i: int = 0;
        var src_ind: int = 0;
        action LOOP_FOR(
            i, offset, end, +1,
            _get_loop(dst, i, src_ind)
        );
    }


    @Phantom proc _get_loop(dst: array<byte>, i: int, src_ind: int): void
    {
        src_ind = _nextGetIndex();
        dst[i] = this.storage[src_ind];
    }


    proc _put(src: array<byte>, offset: int, length: int): void
    {
        var src_length: int = action ARRAY_SIZE(src);
        _checkBounds(offset, length, src_length);
        var rem: int = _remaining();
        if (length > rem)
            action THROW_NEW("java.nio.BufferOverflowException", []);
        var end: int = offset + length;
        var i: int = 0;
        action LOOP_FOR(
            i, offset, end, +1,
            _put_loop(src, i)
        );
    }


    @Phantom proc _put_loop(src: array<byte>, i: int): void
    {
        _put(src[i]);
    }


    proc _put(x: byte): void
    {
        var i: int = _nextPutIndex();
        this.storage[i] = x;
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
        //if (unitSize > 8 && !this.isDirect())   //is direct always return True, comment for oher buffers
        //    action THROW_NEW("java.lang.UnsupportedOperationException", []);
        result = ((this.address + index) % unitSize) as int;
    }


    proc _slice(self: DirectByteBuffer, pos: int, lim: int): DirectByteBuffer
    {
        if (pos < 0 || pos > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (pos >= 0)  and assert (pos <= lim) in original
        var rem: int = lim - pos;

        result = new DirectByteBufferAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = rem, capacity = rem, offset = pos);
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
        var this_pos: int = this.position;
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
        var nextIndex1: long = offset + 1;
        result = _makeShort(this.storage[offset], this.storage[nextIndex1]) as char;
    }


    proc _convEndian(n: char): char
    {
        if (this.bigEndian == true) result = n;
        else result = action CALL_METHOD(null as Character, "reverseBytes", [n]);
    }


    //for putChar

    proc _putChar(offset: long, x: char): void
    {
        var y: short = _convEndian(x) as short;
        _putShortUnaligned(offset, (y >>> 0) as byte, (y >>> 8) as byte);
    }

    //utilities for getDouble

    proc _getDouble(offset: long): double
    {
        var x: long = _getLongUnaligned(offset);
        var endian_x: long = _convEndian(x);
        result = action CALL_METHOD(null as Double, "longBitsToDouble", [endian_x]);
    }

    // for put Double

    proc _putDouble(offset: long, x: double): void
    {
        var conv_x: long = action CALL_METHOD(null as Double, "doubleToRawLongBits", [x]);
        var y: long = _convEndian(conv_x);
        _putLongUnaligned(offset, (y >>> 0) as byte,
                                  (y >>> 8) as byte,
                                  (y >>> 16) as byte,
                                  (y >>> 24) as byte,
                                  (y >>> 32) as byte,
                                  (y >>> 40) as byte,
                                  (y >>> 48) as byte,
                                  (y >>> 56) as byte);
    }


    //utilities for getFloat

    proc _getFloat(offset: long): float
    {
        var x: int = _getIntUnaligned(offset);
        var endian_x: int = _convEndian(x);
        result = action CALL_METHOD(null as Float, "intBitsToFloat", [endian_x]);
    }


    //for putFloat

    proc _putFloat(offset: long, x: float): void
    {
        var conv_x: int = action CALL_METHOD(null as Float, "floatToRawIntBits", [x]);
        var y: int = _convEndian(conv_x);
        _putIntUnaligned(offset, (y >>> 0) as byte,
                                 (y >>> 8) as byte,
                                 (y >>> 16) as byte,
                                 (y >>> 24) as byte);
    }


    //utilities for getInt

    proc _getInt(offset: long): int
    {
        var x: int = _getIntUnaligned(offset);
        result = _convEndian(x);
    }

    proc _getIntUnaligned(offset: long): int
    {
        var nextIndex1: long = offset + 1;
        var nextIndex2: long = offset + 2;
        var nextIndex3: long = offset + 3;

        result = _makeInt(this.storage[offset],
                          this.storage[nextIndex1],
                          this.storage[nextIndex2],
                          this.storage[nextIndex3]);
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


    // for putInt

    proc _putInt(offset: long, x: int): void
    {
        var y: int = _convEndian(x);
        _putIntUnaligned(offset, (y >>> 0) as byte,
                                 (y >>> 8) as byte,
                                 (y >>> 16) as byte,
                                 (y >>> 24) as byte);
    }


    proc _putIntUnaligned(offset: long, i0: byte, i1: byte, i2: byte, i3: byte): void
    {
        var nextIndex1: long = offset + 1;
        var nextIndex2: long = offset + 2;
        var nextIndex3: long = offset + 3;

        this.storage[offset] = _pick(i0, i3);
        this.storage[nextIndex1] = _pick(i1, i2);
        this.storage[nextIndex2] = _pick(i2, i1);
        this.storage[nextIndex3] = _pick(i3, i0);
    }


    //utilities for getLong

    proc _getLong(offset: long): long
    {
        var x: long = _getLongUnaligned(offset);
        result = _convEndian(x);
    }


    proc _getLongUnaligned(offset: long): long
    {
        var nextIndex1: long = offset + 1;
        var nextIndex2: long = offset + 2;
        var nextIndex3: long = offset + 3;
        var nextIndex4: long = offset + 4;
        var nextIndex5: long = offset + 5;
        var nextIndex6: long = offset + 6;
        var nextIndex7: long = offset + 7;

        result = _makeLong(this.storage[offset],
                         this.storage[nextIndex1],
                         this.storage[nextIndex2],
                         this.storage[nextIndex3],
                         this.storage[nextIndex4],
                         this.storage[nextIndex5],
                         this.storage[nextIndex6],
                         this.storage[nextIndex7]);
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


    proc _toUnsignedLong(n: byte): long
    {
        result = n & 255L;
    }


    // for putLong

    proc _putLong(offset: long, x: long): void
    {
        var y: long = _convEndian(x);
        _putLongUnaligned(offset, (y >>> 0) as byte,
                                  (y >>> 8) as byte,
                                  (y >>> 16) as byte,
                                  (y >>> 24) as byte,
                                  (y >>> 32) as byte,
                                  (y >>> 40) as byte,
                                  (y >>> 48) as byte,
                                  (y >>> 56) as byte);
    }


    proc _putLongUnaligned(offset: long, i0: byte, i1: byte, i2: byte, i3: byte, i4: byte, i5: byte, i6: byte, i7: byte): void
    {
        var nextIndex1: long = offset + 1;
        var nextIndex2: long = offset + 2;
        var nextIndex3: long = offset + 3;
        var nextIndex4: long = offset + 4;
        var nextIndex5: long = offset + 5;
        var nextIndex6: long = offset + 6;
        var nextIndex7: long = offset + 7;

        this.storage[offset] = _pick(i0, i7);
        this.storage[nextIndex1] = _pick(i1, i6);
        this.storage[nextIndex2] = _pick(i2, i5);
        this.storage[nextIndex3] = _pick(i3, i4);
        this.storage[nextIndex4] = _pick(i4, i3);
        this.storage[nextIndex5] = _pick(i5, i2);
        this.storage[nextIndex6] = _pick(i6, i1);
        this.storage[nextIndex7] = _pick(i7, i0);
    }


    //utilities for getShort

    proc _getShort(offset: long): short
    {
        var x: short = _getShortUnaligned(offset);
        result = _convEndian(x);
    }


    proc _getShortUnaligned(offset: long): short
    {
        var nextIndex1: long = offset + 1;

        result = _makeShort(this.storage[offset], this.storage[nextIndex1]);
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


    //for putShort

    proc _putShort(offset: long, x: short): void
    {
        var y: short = _convEndian(x);
        _putShortUnaligned(offset, (y >>> 0) as byte, (y >>> 8) as byte);
    }


    proc _putShortUnaligned(offset: long, i0: byte, i1: byte): void
    {
        var nextIndex1: long = offset + 1;

        this.storage[offset] = _pick(i0, i1);
        this.storage[nextIndex1] = _pick(i1, i0);
    }


    //utilities unsafe base

    proc _pickPos(top: int, pos: int): int
    {
        if (this.bigEndian == true) result = top - pos;
        else result = pos;
    }


    proc _pick(le: byte, be: byte): byte
    {
        if (this.bigEndian == true) result = be;
        else result = le;
    }


    // constructors proc

    proc _mappedByteBuffer_constructor(mark: int, pos: int, lim: int, cap: int, fd: FileDescriptor): void
    {
        _byteBuffer_constructor(mark, pos, lim, cap, null, 0);
        this.fd = fd;
    }


    proc _byteBuffer_constructor(mark: int, pos: int, lim: int, cap: int, hb: array<byte>, offset: int): void
    {
        _buffer_constructor(mark, pos, lim, cap);
        this.hb = hb;
        this.offset = offset;
    }


    proc _buffer_constructor(mark: int, pos: int, lim: int, cap: int): void
    {
        if (cap < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        this.capacity = cap;
        this.storage = action ARRAY_NEW("byte", cap);
        this.nativeByteOrder = this.bigEndian == (action CALL_METHOD(null as ByteOrder, "nativeOrder", []) == BYTEORDER_BIG_ENDIAN);
        _limit(lim);
        _position(pos);
        if (mark >= 0)
        {
            if (mark > pos)
                action THROW_NEW("java.lang.IllegalArgumentException", []);
            this.mark = mark;
        }
    }


    // put

    proc _super_put(self: ByteBuffer, src: ByteBuffer): ByteBuffer
    {
        if (src == self)
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        // always false? but if isReadOnly will be override?
        // if (isReadOnly())
        //    action THROW_NEW("java.nio.ReadOnlyBufferException", []);
        var n: int = action CALL_METHOD(src, "remaining", []);

        if (n > _remaining())
            action THROW_NEW("java.nio.BufferOverflowException", []);

        var get_byte: byte = 0 as byte;
        var i: int = 0;
        action LOOP_FOR(
            i, 0, n, +1,
            _super_put_loop(i, src, get_byte)
        );
    }


    @Phantom proc _super_put_loop(i: int, src: ByteBuffer, get_byte: byte): void
    {
        get_byte = action CALL_METHOD(src, "get", []);
        _put(get_byte);
    }


    // constructors

    @private constructor *.`<init>` (@target self: DirectByteBuffer, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        _mappedByteBuffer_constructor(mark, pos, lim, cap, null);
        this.address = action CALL_METHOD(db, "address", []) + off;
        this.cleaner = null;
        this.att = db;
    }


    @private constructor *.`<init>` (@target self: DirectByteBuffer, cap: int)
    {
        _mappedByteBuffer_constructor(-1, 0, cap, cap, null);
        this.cleaner = null;
    }


    @protected constructor *.`<init>` (@target self: DirectByteBuffer, cap: int, addr: long, fd: FileDescriptor, unmapper: Runnable)
    {
        _mappedByteBuffer_constructor(-1, 0, cap, cap, fd);
        this.address = addr;
        this.cleaner = action CALL_METHOD(null as Cleaner, "create", [self, unmapper]);
        this.att = null;
    }


    @private constructor *.`<init>` (@target self: DirectByteBuffer, addr: long, cap: int)
    {
        _mappedByteBuffer_constructor(-1, 0, cap, cap, null);
        this.address = addr;
        this.cleaner = null;
        this.att = null;
    }


    @private constructor *.`<init>` (@target self: DirectByteBuffer, addr: long, cap: int, ob: Object)
    {
        _mappedByteBuffer_constructor(-1, 0, cap, cap, null);
        this.address = addr;
        this.cleaner = null;
        this.att = ob;
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
            aligned_pos += unitSize - pos_mod;

        // Round down the limit to align with unit size
        var aligned_lim: int = lim - lim_mod;

        if (aligned_pos > lim || aligned_lim < pos) {
            aligned_lim = pos;
            aligned_pos = pos;
        }

        result = _slice(self, aligned_pos, aligned_lim);
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
        var off: int = this.position;
        var lim: int = this.limit;
        if (off > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (off <= lim) in original
        var rem: int = _remaining();
        var size: int = rem >> 1;

        if (UNALIGNED == false && ((this.address + off) % (1 << 1) != 0))
        {
            if (this.bigEndian == true) result = (new ByteBufferAsCharBufferBAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as CharBuffer;
            else result = (new ByteBufferAsCharBufferLAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as CharBuffer;
        } else
        {
            if (this.nativeByteOrder == true) result = (new DirectCharBufferUAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as CharBuffer;
            else result = (new DirectCharBufferSAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as CharBuffer;
        }
    }


    fun *.asDoubleBuffer (@target self: DirectByteBuffer): DoubleBuffer
    {
        var off: int = this.position;
        var lim: int = this.limit;
        if (off > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (off <= lim) in original
        var rem: int = _remaining();
        var size: int = rem >> 3;

        if (UNALIGNED == false && ((this.address + off) % (1 << 3) != 0))
        {
            if (this.bigEndian == true) result = (new ByteBufferAsDoubleBufferBAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as DoubleBuffer;
            else result = (new ByteBufferAsDoubleBufferLAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as DoubleBuffer;
        } else
        {
            if (this.nativeByteOrder == true) result = (new DirectDoubleBufferUAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as DoubleBuffer;
            else result = (new DirectDoubleBufferSAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as DoubleBuffer;
        }
    }


    fun *.asFloatBuffer (@target self: DirectByteBuffer): FloatBuffer
    {
        var off: int = this.position;
        var lim: int = this.limit;
        if (off > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (off <= lim) in original
        var rem: int = _remaining();
        var size: int = rem >> 2;

        if (UNALIGNED == false && ((this.address + off) % (1 << 2) != 0))
        {
            if (this.bigEndian == true) result = (new ByteBufferAsFloatBufferBAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as FloatBuffer;
            else result = (new ByteBufferAsFloatBufferLAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as FloatBuffer;
        } else
        {
            if (this.nativeByteOrder == true) result = (new DirectFloatBufferUAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as FloatBuffer;
            else result = (new DirectFloatBufferSAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as FloatBuffer;
        }
    }


    fun *.asIntBuffer (@target self: DirectByteBuffer): IntBuffer
    {
        var off: int = this.position;
        var lim: int = this.limit;
        if (off > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (off <= lim) in original
        var rem: int = _remaining();
        var size: int = rem >> 2;

        if (UNALIGNED == false && ((this.address + off) % (1 << 2) != 0))
        {
            if (this.bigEndian == true) result = (new ByteBufferAsIntBufferBAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as IntBuffer;
            else result = (new ByteBufferAsIntBufferLAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as IntBuffer;
        } else
        {
            if (this.nativeByteOrder == true) result = (new DirectIntBufferUAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as IntBuffer;
            else result = (new DirectIntBufferSAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as IntBuffer;
        }
    }


    fun *.asLongBuffer (@target self: DirectByteBuffer): LongBuffer
    {
        var off: int = this.position;
        var lim: int = this.limit;
        if (off > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (off <= lim) in original
        var rem: int = _remaining();
        var size: int = rem >> 3;

        if (UNALIGNED == false && ((this.address + off) % (1 << 3) != 0))
        {
            if (this.bigEndian == true) result = (new ByteBufferAsLongBufferBAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as LongBuffer;
            else result = (new ByteBufferAsLongBufferLAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as LongBuffer;
        } else
        {
            if (this.nativeByteOrder == true) result = (new DirectLongBufferUAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as LongBuffer;
            else result = (new DirectLongBufferSAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as LongBuffer;
        }
    }


    fun *.asReadOnlyBuffer (@target self: DirectByteBuffer): ByteBuffer
    {
        result = new DirectByteBufferRAutomaton(state = Initialized, att = self, mark = this.mark, position = this.position, limit = this.limit, capacity = this.capacity, offset = 0);
    }


    fun *.asShortBuffer (@target self: DirectByteBuffer): ShortBuffer
    {
        var off: int = this.position;
        var lim: int = this.limit;
        if (off > lim)
            action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (off <= lim) in original
        var rem: int = _remaining();
        var size: int = rem >> 1;

        if (UNALIGNED == false && ((this.address + off) % (1 << 1) != 0))
        {
            if (this.bigEndian == true) result = (new ByteBufferAsShortBufferBAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as ShortBuffer;
            else result = (new ByteBufferAsShortBufferLAutomaton(state = Initialized, bb = self, mark = -1, position = 0, limit = size, capacity = size, address = this.address + off)) as ShortBuffer;
        } else
        {
            if (this.nativeByteOrder == true) result = (new DirectShortBufferUAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as ShortBuffer;
            else result = (new DirectShortBufferSAutomaton(state = Initialized, att = self, mark = -1, position = 0, limit = size, capacity = size, offset = off)) as ShortBuffer;
        }
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
            result = rem - that_rem;
        }
    }


    fun *.duplicate (@target self: DirectByteBuffer): ByteBuffer
    {
        result = new DirectByteBufferAutomaton(state = Initialized, att = self, mark = this.mark, position = this.position, limit = this.limit, capacity = this.capacity, offset = 0);
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
        this.limit = this.position;
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
        var next_index: int = _nextGetIndex(2);
        result = _getChar(next_index as long);
    }


    fun *.getChar (@target self: DirectByteBuffer, i: int): char
    {
        _checkIndex(i, 2);
        result = _getChar(i as long);
    }


    fun *.getDouble (@target self: DirectByteBuffer): double
    {
        var next_index: int = _nextGetIndex(8);
        result = _getDouble(next_index as long);
    }


    fun *.getDouble (@target self: DirectByteBuffer, i: int): double
    {
        _checkIndex(i, 8);
        result = _getDouble(i as long);
    }


    fun *.getFloat (@target self: DirectByteBuffer): float
    {
        var next_index: int = _nextGetIndex(4);
        result = _getFloat(next_index as long);
    }


    fun *.getFloat (@target self: DirectByteBuffer, i: int): float
    {
        _checkIndex(i, 4);
        result = _getFloat(i as long);
    }


    fun *.getInt (@target self: DirectByteBuffer): int
    {
        var next_index: int = _nextGetIndex(4);
        result = _getInt(next_index as long);
    }


    fun *.getInt (@target self: DirectByteBuffer, i: int): int
    {
        _checkIndex(i, 4);
        result = _getInt(i as long);
    }


    fun *.getLong (@target self: DirectByteBuffer): long
    {
        var next_index: int = _nextGetIndex(8);
        result = _getLong(next_index as long);
    }


    fun *.getLong (@target self: DirectByteBuffer, i: int): long
    {
        _checkIndex(i, 8);
        result = _getLong(i as long);
    }


    fun *.getShort (@target self: DirectByteBuffer): short
    {
        var next_index: int = _nextGetIndex(2);
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

        var r: int = _mismatch(this.position, that, len);
        if (r == -1 && _remaining() != that_rem) result = len;
        else result = r;
    }


    // within java.nio.ByteBuffer
    @final fun *.order (@target self: DirectByteBuffer): ByteOrder
    {
        if (this.bigEndian) result = BYTEORDER_BIG_ENDIAN;
        else result = BYTEORDER_LITTLE_ENDIAN;
    }


    // within java.nio.ByteBuffer
    @final fun *.order (@target self: DirectByteBuffer, bo: ByteOrder): ByteBuffer
    {
        this.bigEndian = (bo == BYTEORDER_BIG_ENDIAN);
        this.nativeByteOrder = this.bigEndian == (action CALL_METHOD(null as ByteOrder, "nativeOrder", []) == BYTEORDER_BIG_ENDIAN);
        result = self;
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
        var src_hb: array<byte> = action CALL_METHOD(src, "_hb", []);
        if (src is DirectByteBuffer) {
            if (src == self)
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

            var i: int = 0;
            action LOOP_FOR(
                i, pos, slim, +1,
                _copy_loop(i, src_array, src_i)
            );

            _position(pos + srem);
        } else if (src_hb != null) {

            var spos2: int = action CALL_METHOD(src, "position", []);
            var slim2: int = action CALL_METHOD(src, "limit", []);
            if (spos2 > slim2)
                action THROW_NEW("java.lang.AssertionError", []);   // #warning: assert (spos <= slim) in original

            var srem2: int = slim2 - spos2;
            var src_offset: int = action CALL_METHOD(src, "_offset", []);
            _put(src_hb, src_offset + spos2, srem2);
            action CALL_METHOD(src, "position", [spos2 + srem2]);
        } else {
            _super_put(self, src);
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
        _put(x);
        result = self;
    }


    // within java.nio.ByteBuffer
    @final fun *.put (@target self: DirectByteBuffer, src: array<byte>): ByteBuffer
    {
        var len: int = action ARRAY_SIZE(src);
        _put(src, 0, len);
        result = self;
    }


    fun *.put (@target self: DirectByteBuffer, src: array<byte>, offset: int, length: int): ByteBuffer
    {
        _put(src, offset, length);
        result = self;
    }


    fun *.put (@target self: DirectByteBuffer, i: int, x: byte): ByteBuffer
    {
        _checkIndex(i);
        this.storage[i] = x;
        result = self;
    }


    fun *.putChar (@target self: DirectByteBuffer, x: char): ByteBuffer
    {
        var next_index: int = _nextPutIndex(2);
        _putChar(next_index as long, x);
        result = self;
    }


    fun *.putChar (@target self: DirectByteBuffer, i: int, x: char): ByteBuffer
    {
        _checkIndex(i, 2);
        _putChar(i as long, x);
        result = self;
    }


    fun *.putDouble (@target self: DirectByteBuffer, x: double): ByteBuffer
    {
        var next_index: int = _nextPutIndex(8);
        _putDouble(next_index as long, x);
        result = self;
    }


    fun *.putDouble (@target self: DirectByteBuffer, i: int, x: double): ByteBuffer
    {
        _checkIndex(i, 8);
        _putDouble(i as long, x);
        result = self;
    }


    fun *.putFloat (@target self: DirectByteBuffer, x: float): ByteBuffer
    {
        var next_index: int = _nextPutIndex(4);
        _putFloat(next_index as long, x);
        result = self;
    }


    fun *.putFloat (@target self: DirectByteBuffer, i: int, x: float): ByteBuffer
    {
        _checkIndex(i, 4);
        _putFloat(i as long, x);
        result = self;
    }


    fun *.putInt (@target self: DirectByteBuffer, x: int): ByteBuffer
    {
        var next_index: int = _nextPutIndex(4);
        _putInt(next_index as long, x);
        result = self;
    }


    fun *.putInt (@target self: DirectByteBuffer, i: int, x: int): ByteBuffer
    {
        _checkIndex(i, 4);
        _putInt(i as long, x);
        result = self;
    }


    fun *.putLong (@target self: DirectByteBuffer, i: int, x: long): ByteBuffer
    {
        _checkIndex(i, 8);
        _putLong(i as long, x);
        result = self;
    }


    fun *.putLong (@target self: DirectByteBuffer, x: long): ByteBuffer
    {
        var next_index: int = _nextPutIndex(8);
        _putLong(next_index as long, x);
        result = self;
    }


    fun *.putShort (@target self: DirectByteBuffer, i: int, x: short): ByteBuffer
    {
        _checkIndex(i, 2);
        _putShort(i as long, x);
        result = self;
    }


    fun *.putShort (@target self: DirectByteBuffer, x: short): ByteBuffer
    {
        var next_index: int = _nextPutIndex(2);
        _putShort(next_index as long, x);
        result = self;
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectByteBuffer): int
    {
        result = _remaining();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectByteBuffer): Buffer
    {
        if (this.mark < 0)
            action THROW_NEW("java.nio.InvalidMarkException", []);
        this.position = this.mark;
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
        result = _slice(self, this.position, this.limit);
    }


    fun *.slice (@target self: DirectByteBuffer, pos: int, lim: int): ByteBuffer
    {
        result = _slice(self, pos, lim);
    }


    // within java.nio.ByteBuffer
    fun *.toString (@target self: DirectByteBuffer): String
    {
        result = "DirectByteBuffer[pos=";
        result += action OBJECT_TO_STRING(this.position);
        result += " lim=";
        result += action OBJECT_TO_STRING(this.limit);
        result += " cap=";
        result += action OBJECT_TO_STRING(this.capacity);
        result += "]";
    }
}