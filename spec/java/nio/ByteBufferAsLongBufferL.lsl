libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsLongBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/LongBuffer;


// local semantic types

@extends("java.nio.LongBuffer")
@public @private type ByteBufferAsLongBufferL
    is java.nio.ByteBufferAsLongBufferL
    for Object
{
}


// automata

automaton ByteBufferAsLongBufferLAutomaton
(
)
: ByteBufferAsLongBufferL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsLongBufferL, ByteBuffer),
        `<init>` (ByteBufferAsLongBufferL, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsLongBufferL),
        get (ByteBufferAsLongBufferL, int),
        get (ByteBufferAsLongBufferL, array<long>),
        get (ByteBufferAsLongBufferL, array<long>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsLongBufferL),
        limit (ByteBufferAsLongBufferL, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsLongBufferL),
        position (ByteBufferAsLongBufferL, int),
        put (ByteBufferAsLongBufferL, LongBuffer),
        put (ByteBufferAsLongBufferL, int, long),
        put (ByteBufferAsLongBufferL, long),
        put (ByteBufferAsLongBufferL, array<long>),
        put (ByteBufferAsLongBufferL, array<long>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteBufferAsLongBufferL, bb: ByteBuffer)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: ByteBufferAsLongBufferL, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.LongBuffer
    @final fun *.array (@target self: ByteBufferAsLongBufferL): array<long>
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsLongBufferL): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsLongBufferL): LongBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsLongBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsLongBufferL): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsLongBufferL): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.compareTo (@target self: ByteBufferAsLongBufferL, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsLongBufferL): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.equals (@target self: ByteBufferAsLongBufferL, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsLongBufferL): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsLongBufferL): long
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsLongBufferL, i: int): long
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.get (@target self: ByteBufferAsLongBufferL, dst: array<long>): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.get (@target self: ByteBufferAsLongBufferL, dst: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @final fun *.hasArray (@target self: ByteBufferAsLongBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsLongBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.hashCode (@target self: ByteBufferAsLongBufferL): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsLongBufferL): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsLongBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsLongBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsLongBufferL, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsLongBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.mismatch (@target self: ByteBufferAsLongBufferL, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsLongBufferL): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsLongBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsLongBufferL, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.put (@target self: ByteBufferAsLongBufferL, src: LongBuffer): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsLongBufferL, i: int, x: long): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsLongBufferL, x: long): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @final fun *.put (@target self: ByteBufferAsLongBufferL, src: array<long>): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.put (@target self: ByteBufferAsLongBufferL, src: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsLongBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsLongBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsLongBufferL): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsLongBufferL): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.toString (@target self: ByteBufferAsLongBufferL): String
    {
        action TODO();
    }

}