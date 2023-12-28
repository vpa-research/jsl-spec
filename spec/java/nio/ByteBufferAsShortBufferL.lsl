libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsShortBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/ShortBuffer;


// local semantic types

@extends("java.nio.ShortBuffer")
@public @private type ByteBufferAsShortBufferL
    is java.nio.ByteBufferAsShortBufferL
    for Object
{
}


// automata

automaton ByteBufferAsShortBufferLAutomaton
(
)
: ByteBufferAsShortBufferL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsShortBufferL, ByteBuffer),
        `<init>` (ByteBufferAsShortBufferL, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsShortBufferL),
        get (ByteBufferAsShortBufferL, int),
        get (ByteBufferAsShortBufferL, array<short>),
        get (ByteBufferAsShortBufferL, array<short>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsShortBufferL),
        limit (ByteBufferAsShortBufferL, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsShortBufferL),
        position (ByteBufferAsShortBufferL, int),
        put (ByteBufferAsShortBufferL, ShortBuffer),
        put (ByteBufferAsShortBufferL, int, short),
        put (ByteBufferAsShortBufferL, short),
        put (ByteBufferAsShortBufferL, array<short>),
        put (ByteBufferAsShortBufferL, array<short>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteBufferAsShortBufferL, bb: ByteBuffer)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: ByteBufferAsShortBufferL, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.ShortBuffer
    @final fun *.array (@target self: ByteBufferAsShortBufferL): array<short>
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsShortBufferL): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsShortBufferL): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsShortBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsShortBufferL): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsShortBufferL): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.compareTo (@target self: ByteBufferAsShortBufferL, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsShortBufferL): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.equals (@target self: ByteBufferAsShortBufferL, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsShortBufferL): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsShortBufferL): short
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsShortBufferL, i: int): short
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.get (@target self: ByteBufferAsShortBufferL, dst: array<short>): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.get (@target self: ByteBufferAsShortBufferL, dst: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.hasArray (@target self: ByteBufferAsShortBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsShortBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.hashCode (@target self: ByteBufferAsShortBufferL): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsShortBufferL): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsShortBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsShortBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsShortBufferL, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsShortBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.mismatch (@target self: ByteBufferAsShortBufferL, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsShortBufferL): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsShortBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsShortBufferL, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.put (@target self: ByteBufferAsShortBufferL, src: ShortBuffer): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsShortBufferL, i: int, x: short): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsShortBufferL, x: short): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.put (@target self: ByteBufferAsShortBufferL, src: array<short>): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.put (@target self: ByteBufferAsShortBufferL, src: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsShortBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsShortBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsShortBufferL): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsShortBufferL): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.toString (@target self: ByteBufferAsShortBufferL): String
    {
        action TODO();
    }

}