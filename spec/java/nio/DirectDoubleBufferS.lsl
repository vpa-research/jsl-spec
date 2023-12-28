libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectDoubleBufferS.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/DoubleBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.DoubleBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public @private type DirectDoubleBufferS
    is java.nio.DirectDoubleBufferS
    for Object
{
}


// automata

automaton DirectDoubleBufferSAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: DirectDoubleBufferS
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
        get (DirectDoubleBufferS),
        get (DirectDoubleBufferS, array<double>),
        get (DirectDoubleBufferS, array<double>, int, int),
        get (DirectDoubleBufferS, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectDoubleBufferS),
        limit (DirectDoubleBufferS, int),
        mark,
        mismatch,
        order,
        position (DirectDoubleBufferS),
        position (DirectDoubleBufferS, int),
        put (DirectDoubleBufferS, DoubleBuffer),
        put (DirectDoubleBufferS, double),
        put (DirectDoubleBufferS, array<double>),
        put (DirectDoubleBufferS, array<double>, int, int),
        put (DirectDoubleBufferS, int, double),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectDoubleBufferS, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectDoubleBufferS): long
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.array (@target self: DirectDoubleBufferS): array<double>
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.arrayOffset (@target self: DirectDoubleBufferS): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectDoubleBufferS): DoubleBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectDoubleBufferS): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectDoubleBufferS): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectDoubleBufferS): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectDoubleBufferS): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectDoubleBufferS): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.compareTo (@target self: DirectDoubleBufferS, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectDoubleBufferS): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.equals (@target self: DirectDoubleBufferS, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectDoubleBufferS): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectDoubleBufferS): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.get (@target self: DirectDoubleBufferS, dst: array<double>): DoubleBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectDoubleBufferS, dst: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectDoubleBufferS, i: int): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.hasArray (@target self: DirectDoubleBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectDoubleBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.hashCode (@target self: DirectDoubleBufferS): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectDoubleBufferS): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectDoubleBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectDoubleBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectDoubleBufferS, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectDoubleBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.mismatch (@target self: DirectDoubleBufferS, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectDoubleBufferS): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectDoubleBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectDoubleBufferS, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferS, src: DoubleBuffer): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferS, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @final fun *.put (@target self: DirectDoubleBufferS, src: array<double>): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferS, src: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferS, i: int, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectDoubleBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectDoubleBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectDoubleBufferS): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectDoubleBufferS): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.toString (@target self: DirectDoubleBufferS): String
    {
        action TODO();
    }

}