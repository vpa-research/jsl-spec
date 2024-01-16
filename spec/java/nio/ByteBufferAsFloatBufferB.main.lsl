libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsFloatBufferB.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/FloatBuffer;


// automata

automaton ByteBufferAsFloatBufferBAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsFloatBufferB
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsFloatBufferB, ByteBuffer),
        `<init>` (ByteBufferAsFloatBufferB, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsFloatBufferB),
        get (ByteBufferAsFloatBufferB, array<float>),
        get (ByteBufferAsFloatBufferB, array<float>, int, int),
        get (ByteBufferAsFloatBufferB, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsFloatBufferB),
        limit (ByteBufferAsFloatBufferB, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsFloatBufferB),
        position (ByteBufferAsFloatBufferB, int),
        put (ByteBufferAsFloatBufferB, FloatBuffer),
        put (ByteBufferAsFloatBufferB, float),
        put (ByteBufferAsFloatBufferB, array<float>),
        put (ByteBufferAsFloatBufferB, array<float>, int, int),
        put (ByteBufferAsFloatBufferB, int, float),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: ByteBufferAsFloatBufferB, bb: ByteBuffer)
    {
        action TODO();
    }


    constructor *.`<init>` (@target self: ByteBufferAsFloatBufferB, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.FloatBuffer
    @final fun *.array (@target self: ByteBufferAsFloatBufferB): array<float>
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsFloatBufferB): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsFloatBufferB): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsFloatBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsFloatBufferB): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsFloatBufferB): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.compareTo (@target self: ByteBufferAsFloatBufferB, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsFloatBufferB): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.equals (@target self: ByteBufferAsFloatBufferB, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsFloatBufferB): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsFloatBufferB): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.get (@target self: ByteBufferAsFloatBufferB, dst: array<float>): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.get (@target self: ByteBufferAsFloatBufferB, dst: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsFloatBufferB, i: int): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.hasArray (@target self: ByteBufferAsFloatBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsFloatBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.hashCode (@target self: ByteBufferAsFloatBufferB): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsFloatBufferB): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsFloatBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsFloatBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsFloatBufferB, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsFloatBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.mismatch (@target self: ByteBufferAsFloatBufferB, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsFloatBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsFloatBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsFloatBufferB, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.put (@target self: ByteBufferAsFloatBufferB, src: FloatBuffer): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsFloatBufferB, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.put (@target self: ByteBufferAsFloatBufferB, src: array<float>): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.put (@target self: ByteBufferAsFloatBufferB, src: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsFloatBufferB, i: int, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsFloatBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsFloatBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsFloatBufferB): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsFloatBufferB): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.toString (@target self: ByteBufferAsFloatBufferB): String
    {
        action TODO();
    }

}