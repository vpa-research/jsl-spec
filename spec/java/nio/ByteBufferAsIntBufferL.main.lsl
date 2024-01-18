libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsIntBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/IntBuffer;


// automata

automaton ByteBufferAsIntBufferLAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsIntBufferL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsIntBufferL, ByteBuffer),
        `<init>` (ByteBufferAsIntBufferL, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsIntBufferL),
        get (ByteBufferAsIntBufferL, int),
        get (ByteBufferAsIntBufferL, array<int>),
        get (ByteBufferAsIntBufferL, array<int>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsIntBufferL),
        limit (ByteBufferAsIntBufferL, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsIntBufferL),
        position (ByteBufferAsIntBufferL, int),
        put (ByteBufferAsIntBufferL, IntBuffer),
        put (ByteBufferAsIntBufferL, int),
        put (ByteBufferAsIntBufferL, int, int),
        put (ByteBufferAsIntBufferL, array<int>),
        put (ByteBufferAsIntBufferL, array<int>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: ByteBufferAsIntBufferL, bb: ByteBuffer)
    {
        action TODO();
    }


    constructor *.`<init>` (@target self: ByteBufferAsIntBufferL, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.IntBuffer
    @Phantom @final fun *.array (@target self: ByteBufferAsIntBufferL): array<int>
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.arrayOffset (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsIntBufferL): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: ByteBufferAsIntBufferL): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsIntBufferL): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.compareTo (@target self: ByteBufferAsIntBufferL, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsIntBufferL): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.equals (@target self: ByteBufferAsIntBufferL, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: ByteBufferAsIntBufferL): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsIntBufferL, i: int): int
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: ByteBufferAsIntBufferL, dst: array<int>): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: ByteBufferAsIntBufferL, dst: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.hasArray (@target self: ByteBufferAsIntBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: ByteBufferAsIntBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.hashCode (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsIntBufferL): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsIntBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsIntBufferL, newLimit: int): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: ByteBufferAsIntBufferL): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.mismatch (@target self: ByteBufferAsIntBufferL, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsIntBufferL): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsIntBufferL, newPosition: int): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.put (@target self: ByteBufferAsIntBufferL, src: IntBuffer): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsIntBufferL, x: int): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsIntBufferL, i: int, x: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.put (@target self: ByteBufferAsIntBufferL, src: array<int>): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.put (@target self: ByteBufferAsIntBufferL, src: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: ByteBufferAsIntBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: ByteBufferAsIntBufferL): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: ByteBufferAsIntBufferL): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsIntBufferL): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.toString (@target self: ByteBufferAsIntBufferL): String
    {
        action TODO();
    }

}