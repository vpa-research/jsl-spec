libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsDoubleBufferB.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/DoubleBuffer;


// local semantic types

@extends("java.nio.DoubleBuffer")
@public @private type ByteBufferAsDoubleBufferB
    is java.nio.ByteBufferAsDoubleBufferB
    for Object
{
}


// automata

automaton ByteBufferAsDoubleBufferBAutomaton
(
)
: ByteBufferAsDoubleBufferB
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsDoubleBufferB, ByteBuffer),
        `<init>` (ByteBufferAsDoubleBufferB, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsDoubleBufferB),
        get (ByteBufferAsDoubleBufferB, array<double>),
        get (ByteBufferAsDoubleBufferB, array<double>, int, int),
        get (ByteBufferAsDoubleBufferB, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsDoubleBufferB),
        limit (ByteBufferAsDoubleBufferB, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsDoubleBufferB),
        position (ByteBufferAsDoubleBufferB, int),
        put (ByteBufferAsDoubleBufferB, DoubleBuffer),
        put (ByteBufferAsDoubleBufferB, double),
        put (ByteBufferAsDoubleBufferB, array<double>),
        put (ByteBufferAsDoubleBufferB, array<double>, int, int),
        put (ByteBufferAsDoubleBufferB, int, double),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteBufferAsDoubleBufferB, bb: ByteBuffer)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: ByteBufferAsDoubleBufferB, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.DoubleBuffer
    @final fun *.array (@target self: ByteBufferAsDoubleBufferB): array<double>
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsDoubleBufferB): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsDoubleBufferB): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsDoubleBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsDoubleBufferB): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsDoubleBufferB): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.compareTo (@target self: ByteBufferAsDoubleBufferB, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsDoubleBufferB): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.equals (@target self: ByteBufferAsDoubleBufferB, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsDoubleBufferB): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsDoubleBufferB): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.get (@target self: ByteBufferAsDoubleBufferB, dst: array<double>): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.get (@target self: ByteBufferAsDoubleBufferB, dst: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsDoubleBufferB, i: int): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.hasArray (@target self: ByteBufferAsDoubleBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsDoubleBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.hashCode (@target self: ByteBufferAsDoubleBufferB): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsDoubleBufferB): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsDoubleBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsDoubleBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsDoubleBufferB, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsDoubleBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.mismatch (@target self: ByteBufferAsDoubleBufferB, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsDoubleBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsDoubleBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsDoubleBufferB, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.put (@target self: ByteBufferAsDoubleBufferB, src: DoubleBuffer): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsDoubleBufferB, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.put (@target self: ByteBufferAsDoubleBufferB, src: array<double>): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.put (@target self: ByteBufferAsDoubleBufferB, src: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsDoubleBufferB, i: int, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsDoubleBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsDoubleBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsDoubleBufferB): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsDoubleBufferB): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.toString (@target self: ByteBufferAsDoubleBufferB): String
    {
        action TODO();
    }

}