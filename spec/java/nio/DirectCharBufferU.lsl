libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectCharBufferU.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/util/stream/IntStream;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.CharBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public @private type DirectCharBufferU
    is java.nio.DirectCharBufferU
    for Object
{
}


// automata

automaton DirectCharBufferUAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: DirectCharBufferU
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
        append (DirectCharBufferU, CharSequence),
        append (DirectCharBufferU, CharSequence, int, int),
        append (DirectCharBufferU, char),
        array,
        arrayOffset,
        asReadOnlyBuffer,
        attachment,
        capacity,
        charAt,
        chars,
        cleaner,
        clear,
        codePoints,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        get (DirectCharBufferU),
        get (DirectCharBufferU, array<char>),
        get (DirectCharBufferU, array<char>, int, int),
        get (DirectCharBufferU, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        length,
        limit (DirectCharBufferU),
        limit (DirectCharBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectCharBufferU),
        position (DirectCharBufferU, int),
        put (DirectCharBufferU, CharBuffer),
        put (DirectCharBufferU, String),
        put (DirectCharBufferU, String, int, int),
        put (DirectCharBufferU, char),
        put (DirectCharBufferU, array<char>),
        put (DirectCharBufferU, array<char>, int, int),
        put (DirectCharBufferU, int, char),
        read,
        remaining,
        reset,
        rewind,
        slice,
        subSequence,
        toString (DirectCharBufferU),
        toString (DirectCharBufferU, int, int),
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectCharBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectCharBufferU): long
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: DirectCharBufferU, csq: CharSequence): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: DirectCharBufferU, csq: CharSequence, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: DirectCharBufferU, c: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.array (@target self: DirectCharBufferU): array<char>
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.arrayOffset (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectCharBufferU): CharBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectCharBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.charAt (@target self: DirectCharBufferU, index: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.chars (@target self: DirectCharBufferU): IntStream
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectCharBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectCharBufferU): Buffer
    {
        action TODO();
    }


    // within java.lang.CharSequence
    fun *.codePoints (@target self: DirectCharBufferU): IntStream
    {
        action TODO();
    }


    fun *.compact (@target self: DirectCharBufferU): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.compareTo (@target self: DirectCharBufferU, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectCharBufferU): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.equals (@target self: DirectCharBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectCharBufferU): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectCharBufferU): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.get (@target self: DirectCharBufferU, dst: array<char>): CharBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectCharBufferU, dst: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectCharBufferU, i: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.hasArray (@target self: DirectCharBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectCharBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.hashCode (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectCharBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectCharBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.length (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectCharBufferU, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectCharBufferU): Buffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.mismatch (@target self: DirectCharBufferU, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectCharBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectCharBufferU, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferU, src: CharBuffer): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.put (@target self: DirectCharBufferU, src: String): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: DirectCharBufferU, src: String, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferU, x: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.put (@target self: DirectCharBufferU, src: array<char>): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferU, src: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferU, i: int, x: char): CharBuffer
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    // within java.nio.CharBuffer
    fun *.read (@target self: DirectCharBufferU, _target: CharBuffer): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectCharBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectCharBufferU): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectCharBufferU): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectCharBufferU): CharBuffer
    {
        action TODO();
    }


    fun *.subSequence (@target self: DirectCharBufferU, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.toString (@target self: DirectCharBufferU): String
    {
        action TODO();
    }


    fun *.toString (@target self: DirectCharBufferU, start: int, end: int): String
    {
        action TODO();
    }

}