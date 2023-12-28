libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectIntBufferU.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/IntBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.IntBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public @private type DirectIntBufferU
    is java.nio.DirectIntBufferU
    for Object
{
}


// automata

automaton DirectIntBufferUAutomaton
(
)
: DirectIntBufferU
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
    ];

    shift Initialized -> self by [
        // instance methods
        address,
        array,
        arrayOffset,
        asReadOnlyBuffer,
        attachment,
        capacity,
        cleaner,
        clear,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        get (DirectIntBufferU),
        get (DirectIntBufferU, int),
        get (DirectIntBufferU, array<int>),
        get (DirectIntBufferU, array<int>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectIntBufferU),
        limit (DirectIntBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectIntBufferU),
        position (DirectIntBufferU, int),
        put (DirectIntBufferU, IntBuffer),
        put (DirectIntBufferU, int),
        put (DirectIntBufferU, int, int),
        put (DirectIntBufferU, array<int>),
        put (DirectIntBufferU, array<int>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectIntBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectIntBufferU): long
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.array (@target self: DirectIntBufferU): array<int>
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.arrayOffset (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectIntBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectIntBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectIntBufferU): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.compareTo (@target self: DirectIntBufferU, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.equals (@target self: DirectIntBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectIntBufferU): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferU, i: int): int
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: DirectIntBufferU, dst: array<int>): IntBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferU, dst: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.hasArray (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.hashCode (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectIntBufferU, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectIntBufferU): Buffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.mismatch (@target self: DirectIntBufferU, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectIntBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectIntBufferU, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, src: IntBuffer): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, x: int): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, i: int, x: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.put (@target self: DirectIntBufferU, src: array<int>): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, src: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectIntBufferU): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectIntBufferU): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.toString (@target self: DirectIntBufferU): String
    {
        action TODO();
    }

}