libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsLongBufferB.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/LongBuffer;


// automata

automaton ByteBufferAsLongBufferBAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsLongBufferB
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsLongBufferB, ByteBuffer),
        `<init>` (ByteBufferAsLongBufferB, ByteBuffer, int, int, int, int, long),
    ];

    shift Initialized -> self by [
        // instance methods
        array,
        arrayOffset,
        asReadOnlyBuffer,
        capacity,
        clear,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        get (ByteBufferAsLongBufferB),
        get (ByteBufferAsLongBufferB, int),
        get (ByteBufferAsLongBufferB, array<long>),
        get (ByteBufferAsLongBufferB, array<long>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsLongBufferB),
        limit (ByteBufferAsLongBufferB, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsLongBufferB),
        position (ByteBufferAsLongBufferB, int),
        put (ByteBufferAsLongBufferB, LongBuffer),
        put (ByteBufferAsLongBufferB, int, long),
        put (ByteBufferAsLongBufferB, long),
        put (ByteBufferAsLongBufferB, array<long>),
        put (ByteBufferAsLongBufferB, array<long>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: ByteBufferAsLongBufferB, bb: ByteBuffer)
    {
        action TODO();
    }


    constructor *.`<init>` (@target self: ByteBufferAsLongBufferB, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.LongBuffer
    @Phantom @final fun *.array (@target self: ByteBufferAsLongBufferB): array<long>
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.arrayOffset (@target self: ByteBufferAsLongBufferB): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsLongBufferB): LongBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: ByteBufferAsLongBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: ByteBufferAsLongBufferB): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsLongBufferB): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.compareTo (@target self: ByteBufferAsLongBufferB, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsLongBufferB): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.equals (@target self: ByteBufferAsLongBufferB, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: ByteBufferAsLongBufferB): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsLongBufferB): long
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsLongBufferB, i: int): long
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.get (@target self: ByteBufferAsLongBufferB, dst: array<long>): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.get (@target self: ByteBufferAsLongBufferB, dst: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.hasArray (@target self: ByteBufferAsLongBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: ByteBufferAsLongBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.hashCode (@target self: ByteBufferAsLongBufferB): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsLongBufferB): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsLongBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsLongBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsLongBufferB, newLimit: int): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: ByteBufferAsLongBufferB): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.mismatch (@target self: ByteBufferAsLongBufferB, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsLongBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsLongBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsLongBufferB, newPosition: int): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.put (@target self: ByteBufferAsLongBufferB, src: LongBuffer): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsLongBufferB, i: int, x: long): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsLongBufferB, x: long): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.put (@target self: ByteBufferAsLongBufferB, src: array<long>): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.put (@target self: ByteBufferAsLongBufferB, src: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: ByteBufferAsLongBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: ByteBufferAsLongBufferB): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: ByteBufferAsLongBufferB): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsLongBufferB): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.toString (@target self: ByteBufferAsLongBufferB): String
    {
        action TODO();
    }

}