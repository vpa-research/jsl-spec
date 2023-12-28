libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsShortBufferB.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/ShortBuffer;


// local semantic types

@extends("java.nio.ShortBuffer")
@public @private type ByteBufferAsShortBufferB
    is java.nio.ByteBufferAsShortBufferB
    for Object
{
}


// automata

automaton ByteBufferAsShortBufferBAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: int
)
: ByteBufferAsShortBufferB
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsShortBufferB, ByteBuffer),
        `<init>` (ByteBufferAsShortBufferB, ByteBuffer, int, int, int, int, long),
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
        get (ByteBufferAsShortBufferB),
        get (ByteBufferAsShortBufferB, int),
        get (ByteBufferAsShortBufferB, array<short>),
        get (ByteBufferAsShortBufferB, array<short>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (ByteBufferAsShortBufferB),
        limit (ByteBufferAsShortBufferB, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsShortBufferB),
        position (ByteBufferAsShortBufferB, int),
        put (ByteBufferAsShortBufferB, ShortBuffer),
        put (ByteBufferAsShortBufferB, int, short),
        put (ByteBufferAsShortBufferB, short),
        put (ByteBufferAsShortBufferB, array<short>),
        put (ByteBufferAsShortBufferB, array<short>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteBufferAsShortBufferB, bb: ByteBuffer)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: ByteBufferAsShortBufferB, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.ShortBuffer
    @final fun *.array (@target self: ByteBufferAsShortBufferB): array<short>
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsShortBufferB): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsShortBufferB): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsShortBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsShortBufferB): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsShortBufferB): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.compareTo (@target self: ByteBufferAsShortBufferB, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsShortBufferB): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.equals (@target self: ByteBufferAsShortBufferB, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsShortBufferB): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsShortBufferB): short
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsShortBufferB, i: int): short
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.get (@target self: ByteBufferAsShortBufferB, dst: array<short>): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.get (@target self: ByteBufferAsShortBufferB, dst: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.hasArray (@target self: ByteBufferAsShortBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsShortBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.hashCode (@target self: ByteBufferAsShortBufferB): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsShortBufferB): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsShortBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsShortBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsShortBufferB, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsShortBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.mismatch (@target self: ByteBufferAsShortBufferB, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsShortBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsShortBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsShortBufferB, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.put (@target self: ByteBufferAsShortBufferB, src: ShortBuffer): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsShortBufferB, i: int, x: short): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsShortBufferB, x: short): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.put (@target self: ByteBufferAsShortBufferB, src: array<short>): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.put (@target self: ByteBufferAsShortBufferB, src: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsShortBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsShortBufferB): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsShortBufferB): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsShortBufferB): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.toString (@target self: ByteBufferAsShortBufferB): String
    {
        action TODO();
    }

}