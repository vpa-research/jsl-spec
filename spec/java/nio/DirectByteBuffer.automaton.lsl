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

    // utilities

    proc _get(i: int): byte {
        var ind: int = _nextIndex(i);
        result = this.storage[ind];
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

    proc _nextIndex(): int
    {
        if (this.position >= this.limit)
            action THROW_NEW("java.nio.BufferUnderflowException", []);
        this.position += 1;
        result = this.position;
    }

    proc _nextIndex(nb: int): int
    {
        if (this.limit - this.position < nb)
            action THROW_NEW("java.nio.BufferUnderflowException", []);
        var p: int = this.position;
        this.position += nb;
        result = p;
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

        var rem: int = lim - pos;

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

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            _mismatch_loop(i, that, that_pos)
        );

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

    @Phantom proc _mismatch_loop(i: int, that: ByteBuffer, that_pos: int): void
    {
        var that_got_loop: byte = action CALL_METHOD(that, "get", [that_pos + i]);
        var this_got_loop: byte = _get(this.position + i);
        if (that_got_loop != this_got_loop);
            action LOOP_BREAK();
    }


    fun *.duplicate (@target self: DirectByteBuffer): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.equals (@target self: DirectByteBuffer, ob: Object): boolean
    {
        action TODO();
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
        action TODO();
    }


    fun *.get (@target self: DirectByteBuffer): byte
    {
        var ind: int = _nextIndex();
        result = this.storage[ind];
    }


    // within java.nio.ByteBuffer
    fun *.get (@target self: DirectByteBuffer, dst: array<byte>): ByteBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectByteBuffer, dst: array<byte>, offset: int, length: int): ByteBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectByteBuffer, i: int): byte
    {
        result = _get(i);
    }


    fun *.getChar (@target self: DirectByteBuffer): char
    {
        action TODO();
    }


    fun *.getChar (@target self: DirectByteBuffer, i: int): char
    {
        action TODO();
    }


    fun *.getDouble (@target self: DirectByteBuffer): double
    {
        action TODO();
    }


    fun *.getDouble (@target self: DirectByteBuffer, i: int): double
    {
        action TODO();
    }


    fun *.getFloat (@target self: DirectByteBuffer): float
    {
        action TODO();
    }


    fun *.getFloat (@target self: DirectByteBuffer, i: int): float
    {
        action TODO();
    }


    fun *.getInt (@target self: DirectByteBuffer): int
    {
        action TODO();
    }


    fun *.getInt (@target self: DirectByteBuffer, i: int): int
    {
        action TODO();
    }


    fun *.getLong (@target self: DirectByteBuffer): long
    {
        action TODO();
    }


    fun *.getLong (@target self: DirectByteBuffer, i: int): long
    {
        action TODO();
    }


    fun *.getShort (@target self: DirectByteBuffer): short
    {
        action TODO();
    }


    fun *.getShort (@target self: DirectByteBuffer, i: int): short
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.hasArray (@target self: DirectByteBuffer): boolean
    {
        action TODO();
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
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectByteBuffer): boolean
    {
        action TODO();
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
        action TODO();
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
        action TODO();
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
        action TODO();
    }


    fun *.put (@target self: DirectByteBuffer, x: byte): ByteBuffer
    {
        action TODO();
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
        action TODO();
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