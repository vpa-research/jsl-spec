libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectShortBufferS.java";

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
@public @private type DirectShortBufferS
    is java.nio.DirectShortBufferS
    for Object
{
}


// automata

automaton DirectShortBufferSAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: DirectShortBufferS
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
        get (DirectShortBufferS),
        get (DirectShortBufferS, int),
        get (DirectShortBufferS, array<short>),
        get (DirectShortBufferS, array<short>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectShortBufferS),
        limit (DirectShortBufferS, int),
        mark,
        mismatch,
        order,
        position (DirectShortBufferS),
        position (DirectShortBufferS, int),
        put (DirectShortBufferS, ShortBuffer),
        put (DirectShortBufferS, int, short),
        put (DirectShortBufferS, short),
        put (DirectShortBufferS, array<short>),
        put (DirectShortBufferS, array<short>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectShortBufferS, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectShortBufferS): long
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.array (@target self: DirectShortBufferS): array<short>
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.arrayOffset (@target self: DirectShortBufferS): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectShortBufferS): ShortBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectShortBufferS): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectShortBufferS): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectShortBufferS): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectShortBufferS): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectShortBufferS): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.compareTo (@target self: DirectShortBufferS, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectShortBufferS): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.equals (@target self: DirectShortBufferS, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectShortBufferS): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectShortBufferS): short
    {
        action TODO();
    }


    fun *.get (@target self: DirectShortBufferS, i: int): short
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.get (@target self: DirectShortBufferS, dst: array<short>): ShortBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectShortBufferS, dst: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.hasArray (@target self: DirectShortBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectShortBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.hashCode (@target self: DirectShortBufferS): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectShortBufferS): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectShortBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectShortBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectShortBufferS, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectShortBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.mismatch (@target self: DirectShortBufferS, that: ShortBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectShortBufferS): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectShortBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectShortBufferS, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferS, src: ShortBuffer): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferS, i: int, x: short): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferS, x: short): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    @final fun *.put (@target self: DirectShortBufferS, src: array<short>): ShortBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectShortBufferS, src: array<short>, offset: int, length: int): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectShortBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectShortBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectShortBufferS): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectShortBufferS): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.ShortBuffer
    fun *.toString (@target self: DirectShortBufferS): String
    {
        action TODO();
    }

}