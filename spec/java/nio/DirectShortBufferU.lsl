libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectShortBufferU.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/ShortBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.ShortBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public @private type DirectShortBufferU
    is java.nio.DirectShortBufferU
    for Object
{
}


// automata

automaton DirectShortBufferUAutomaton
(
)
: DirectShortBufferU
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
        get (DirectShortBufferU),
        get (DirectShortBufferU, int),
        get (DirectShortBufferU, array<short>),
        get (DirectShortBufferU, array<short>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectShortBufferU),
        limit (DirectShortBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectShortBufferU),
        position (DirectShortBufferU, int),
        put (DirectShortBufferU, ShortBuffer),
        put (DirectShortBufferU, int, short),
        put (DirectShortBufferU, short),
        put (DirectShortBufferU, array<short>),
        put (DirectShortBufferU, array<short>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectShortBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectShortBufferU): long
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.array (@target self: DirectShortBufferU): array<short>
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.arrayOffset (@target self: DirectShortBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectShortBufferU): ShortBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectShortBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectShortBufferU): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectShortBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectShortBufferU): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectShortBufferU): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.compareTo (@target self: DirectShortBufferU, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectShortBufferU): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.equals (@target self: DirectShortBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectShortBufferU): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectShortBufferU): short
    {
        action TODO();
    }


    fun *.get (@target self: DirectShortBufferU, i: int): short
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.get (@target self: DirectShortBufferU, dst: array<short>): ShortBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectShortBufferU, dst: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.hasArray (@target self: DirectShortBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectShortBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.hashCode (@target self: DirectShortBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectShortBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectShortBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectShortBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectShortBufferU, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectShortBufferU): Buffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.mismatch (@target self: DirectShortBufferU, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectShortBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectShortBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectShortBufferU, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferU, src: ShortBuffer): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferU, i: int, x: short): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferU, x: short): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.put (@target self: DirectShortBufferU, src: array<short>): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferU, src: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectShortBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectShortBufferU): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectShortBufferU): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectShortBufferU): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.toString (@target self: DirectShortBufferU): String
    {
        action TODO();
    }

}