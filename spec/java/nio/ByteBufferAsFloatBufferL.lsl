libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsFloatBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/FloatBuffer;


// local semantic types

@extends("java.nio.FloatBuffer")
@public @private type ByteBufferAsFloatBufferL
    is java.nio.ByteBufferAsFloatBufferL
    for Object
{
}


// automata

automaton ByteBufferAsFloatBufferLAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: int
)
: ByteBufferAsFloatBufferL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsFloatBufferL, ByteBuffer),
        `<init>` (ByteBufferAsFloatBufferL, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsFloatBufferL),
        get (ByteBufferAsFloatBufferL, array<float>),
        get (ByteBufferAsFloatBufferL, array<float>, int, int),
        get (ByteBufferAsFloatBufferL, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsFloatBufferL),
        limit (ByteBufferAsFloatBufferL, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsFloatBufferL),
        position (ByteBufferAsFloatBufferL, int),
        put (ByteBufferAsFloatBufferL, FloatBuffer),
        put (ByteBufferAsFloatBufferL, float),
        put (ByteBufferAsFloatBufferL, array<float>),
        put (ByteBufferAsFloatBufferL, array<float>, int, int),
        put (ByteBufferAsFloatBufferL, int, float),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteBufferAsFloatBufferL, bb: ByteBuffer)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: ByteBufferAsFloatBufferL, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.FloatBuffer
    @final fun *.array (@target self: ByteBufferAsFloatBufferL): array<float>
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsFloatBufferL): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsFloatBufferL): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsFloatBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsFloatBufferL): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsFloatBufferL): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.compareTo (@target self: ByteBufferAsFloatBufferL, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsFloatBufferL): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.equals (@target self: ByteBufferAsFloatBufferL, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsFloatBufferL): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsFloatBufferL): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.get (@target self: ByteBufferAsFloatBufferL, dst: array<float>): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.get (@target self: ByteBufferAsFloatBufferL, dst: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsFloatBufferL, i: int): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.hasArray (@target self: ByteBufferAsFloatBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsFloatBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.hashCode (@target self: ByteBufferAsFloatBufferL): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsFloatBufferL): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsFloatBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsFloatBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsFloatBufferL, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsFloatBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.mismatch (@target self: ByteBufferAsFloatBufferL, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsFloatBufferL): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsFloatBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsFloatBufferL, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.put (@target self: ByteBufferAsFloatBufferL, src: FloatBuffer): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsFloatBufferL, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.put (@target self: ByteBufferAsFloatBufferL, src: array<float>): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.put (@target self: ByteBufferAsFloatBufferL, src: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsFloatBufferL, i: int, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsFloatBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsFloatBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsFloatBufferL): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsFloatBufferL): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.toString (@target self: ByteBufferAsFloatBufferL): String
    {
        action TODO();
    }

}