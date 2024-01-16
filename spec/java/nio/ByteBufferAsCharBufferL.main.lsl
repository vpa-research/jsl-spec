libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsCharBufferL.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/util/stream/IntStream;


// automata

automaton ByteBufferAsCharBufferLAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsCharBufferL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsCharBufferL, ByteBuffer),
        `<init>` (ByteBufferAsCharBufferL, ByteBuffer, int, int, int, int, long),
    ];

    shift Initialized -> self by [
        // instance methods
        append (ByteBufferAsCharBufferL, CharSequence),
        append (ByteBufferAsCharBufferL, CharSequence, int, int),
        append (ByteBufferAsCharBufferL, char),
        array,
        arrayOffset,
        asReadOnlyBuffer,
        capacity,
        charAt,
        chars,
        clear,
        codePoints,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        get (ByteBufferAsCharBufferL),
        get (ByteBufferAsCharBufferL, array<char>),
        get (ByteBufferAsCharBufferL, array<char>, int, int),
        get (ByteBufferAsCharBufferL, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        length,
        limit (ByteBufferAsCharBufferL),
        limit (ByteBufferAsCharBufferL, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsCharBufferL),
        position (ByteBufferAsCharBufferL, int),
        put (ByteBufferAsCharBufferL, CharBuffer),
        put (ByteBufferAsCharBufferL, String),
        put (ByteBufferAsCharBufferL, String, int, int),
        put (ByteBufferAsCharBufferL, char),
        put (ByteBufferAsCharBufferL, array<char>),
        put (ByteBufferAsCharBufferL, array<char>, int, int),
        put (ByteBufferAsCharBufferL, int, char),
        read,
        remaining,
        reset,
        rewind,
        slice,
        subSequence,
        toString (ByteBufferAsCharBufferL),
        toString (ByteBufferAsCharBufferL, int, int),
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: ByteBufferAsCharBufferL, bb: ByteBuffer)
    {
        action TODO();
    }


    constructor *.`<init>` (@target self: ByteBufferAsCharBufferL, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.CharBuffer
    fun *.append (@target self: ByteBufferAsCharBufferL, csq: CharSequence): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: ByteBufferAsCharBufferL, csq: CharSequence, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: ByteBufferAsCharBufferL, c: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.array (@target self: ByteBufferAsCharBufferL): array<char>
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.arrayOffset (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsCharBufferL): CharBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.charAt (@target self: ByteBufferAsCharBufferL, index: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.chars (@target self: ByteBufferAsCharBufferL): IntStream
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: ByteBufferAsCharBufferL): Buffer
    {
        action TODO();
    }


    // within java.lang.CharSequence
    fun *.codePoints (@target self: ByteBufferAsCharBufferL): IntStream
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsCharBufferL): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.compareTo (@target self: ByteBufferAsCharBufferL, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsCharBufferL): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.equals (@target self: ByteBufferAsCharBufferL, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: ByteBufferAsCharBufferL): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsCharBufferL): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.get (@target self: ByteBufferAsCharBufferL, dst: array<char>): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.get (@target self: ByteBufferAsCharBufferL, dst: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsCharBufferL, i: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.hasArray (@target self: ByteBufferAsCharBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: ByteBufferAsCharBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.hashCode (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsCharBufferL): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsCharBufferL): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.length (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: ByteBufferAsCharBufferL, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: ByteBufferAsCharBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.mismatch (@target self: ByteBufferAsCharBufferL, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsCharBufferL): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: ByteBufferAsCharBufferL, newPosition: int): Buffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: ByteBufferAsCharBufferL, src: CharBuffer): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.put (@target self: ByteBufferAsCharBufferL, src: String): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: ByteBufferAsCharBufferL, src: String, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsCharBufferL, x: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.put (@target self: ByteBufferAsCharBufferL, src: array<char>): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: ByteBufferAsCharBufferL, src: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsCharBufferL, i: int, x: char): CharBuffer
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    // within java.nio.CharBuffer
    fun *.read (@target self: ByteBufferAsCharBufferL, _target: CharBuffer): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: ByteBufferAsCharBufferL): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: ByteBufferAsCharBufferL): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: ByteBufferAsCharBufferL): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsCharBufferL): CharBuffer
    {
        action TODO();
    }


    fun *.subSequence (@target self: ByteBufferAsCharBufferL, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.toString (@target self: ByteBufferAsCharBufferL): String
    {
        action TODO();
    }


    fun *.toString (@target self: ByteBufferAsCharBufferL, start: int, end: int): String
    {
        action TODO();
    }

}