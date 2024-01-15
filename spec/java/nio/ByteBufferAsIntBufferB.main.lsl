libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsIntBufferB.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/IntBuffer;


// automata

automaton ByteBufferAsIntBufferBAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsIntBufferB
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsIntBufferB, ByteBuffer),
        `<init>` (ByteBufferAsIntBufferB, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsIntBufferB),
        get (ByteBufferAsIntBufferB, int),
        get (ByteBufferAsIntBufferB, array<int>),
        get (ByteBufferAsIntBufferB, array<int>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsIntBufferB),
        limit (ByteBufferAsIntBufferB, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsIntBufferB),
        position (ByteBufferAsIntBufferB, int),
        put (ByteBufferAsIntBufferB, IntBuffer),
        put (ByteBufferAsIntBufferB, int),
        put (ByteBufferAsIntBufferB, int, int),
        put (ByteBufferAsIntBufferB, array<int>),
        put (ByteBufferAsIntBufferB, array<int>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteBufferAsIntBufferB, bb: ByteBuffer)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: ByteBufferAsIntBufferB, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.IntBuffer
    @final fun *.array (@target self: ByteBufferAsIntBufferB): array<int>
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsIntBufferB): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsIntBufferB): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsIntBufferB): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.compareTo (@target self: ByteBufferAsIntBufferB, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsIntBufferB): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.equals (@target self: ByteBufferAsIntBufferB, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsIntBufferB): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsIntBufferB, i: int): int
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: ByteBufferAsIntBufferB, dst: array<int>): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: ByteBufferAsIntBufferB, dst: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.hasArray (@target self: ByteBufferAsIntBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsIntBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.hashCode (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsIntBufferB): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsIntBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsIntBufferB, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsIntBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.mismatch (@target self: ByteBufferAsIntBufferB, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsIntBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsIntBufferB, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.put (@target self: ByteBufferAsIntBufferB, src: IntBuffer): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsIntBufferB, x: int): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsIntBufferB, i: int, x: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.put (@target self: ByteBufferAsIntBufferB, src: array<int>): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.put (@target self: ByteBufferAsIntBufferB, src: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsIntBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsIntBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsIntBufferB): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsIntBufferB): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.toString (@target self: ByteBufferAsIntBufferB): String
    {
        action TODO();
    }

}