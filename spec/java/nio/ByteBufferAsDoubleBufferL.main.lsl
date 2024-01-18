libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsDoubleBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/DoubleBuffer;


// automata

automaton ByteBufferAsDoubleBufferLAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsDoubleBufferL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsDoubleBufferL, ByteBuffer),
        `<init>` (ByteBufferAsDoubleBufferL, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsDoubleBufferL),
        get (ByteBufferAsDoubleBufferL, array<double>),
        get (ByteBufferAsDoubleBufferL, array<double>, int, int),
        get (ByteBufferAsDoubleBufferL, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsDoubleBufferL),
        limit (ByteBufferAsDoubleBufferL, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsDoubleBufferL),
        position (ByteBufferAsDoubleBufferL, int),
        put (ByteBufferAsDoubleBufferL, DoubleBuffer),
        put (ByteBufferAsDoubleBufferL, double),
        put (ByteBufferAsDoubleBufferL, array<double>),
        put (ByteBufferAsDoubleBufferL, array<double>, int, int),
        put (ByteBufferAsDoubleBufferL, int, double),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: ByteBufferAsDoubleBufferL, bb: ByteBuffer)
    {
        action TODO();
    }


    constructor *.`<init>` (@target self: ByteBufferAsDoubleBufferL, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.DoubleBuffer
    @Phantom @final fun *.array (@target self: ByteBufferAsDoubleBufferL): array<double>
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.arrayOffset (@target self: ByteBufferAsDoubleBufferL): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsDoubleBufferL): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: ByteBufferAsDoubleBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: ByteBufferAsDoubleBufferL): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsDoubleBufferL): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.compareTo (@target self: ByteBufferAsDoubleBufferL, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsDoubleBufferL): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.equals (@target self: ByteBufferAsDoubleBufferL, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: ByteBufferAsDoubleBufferL): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsDoubleBufferL): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.get (@target self: ByteBufferAsDoubleBufferL, dst: array<double>): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.get (@target self: ByteBufferAsDoubleBufferL, dst: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsDoubleBufferL, i: int): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.hasArray (@target self: ByteBufferAsDoubleBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: ByteBufferAsDoubleBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.hashCode (@target self: ByteBufferAsDoubleBufferL): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsDoubleBufferL): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsDoubleBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsDoubleBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsDoubleBufferL, newLimit: int): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: ByteBufferAsDoubleBufferL): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.mismatch (@target self: ByteBufferAsDoubleBufferL, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsDoubleBufferL): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsDoubleBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsDoubleBufferL, newPosition: int): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.put (@target self: ByteBufferAsDoubleBufferL, src: DoubleBuffer): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsDoubleBufferL, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.put (@target self: ByteBufferAsDoubleBufferL, src: array<double>): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.put (@target self: ByteBufferAsDoubleBufferL, src: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsDoubleBufferL, i: int, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: ByteBufferAsDoubleBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: ByteBufferAsDoubleBufferL): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: ByteBufferAsDoubleBufferL): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsDoubleBufferL): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.toString (@target self: ByteBufferAsDoubleBufferL): String
    {
        action TODO();
    }

}