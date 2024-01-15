libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectCharBufferS.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/util/stream/IntStream;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectCharBufferSAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectCharBufferS
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
        append (DirectCharBufferS, CharSequence),
        append (DirectCharBufferS, CharSequence, int, int),
        append (DirectCharBufferS, char),
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
        get (DirectCharBufferS),
        get (DirectCharBufferS, array<char>),
        get (DirectCharBufferS, array<char>, int, int),
        get (DirectCharBufferS, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        length,
        limit (DirectCharBufferS),
        limit (DirectCharBufferS, int),
        mark,
        mismatch,
        order,
        position (DirectCharBufferS),
        position (DirectCharBufferS, int),
        put (DirectCharBufferS, CharBuffer),
        put (DirectCharBufferS, String),
        put (DirectCharBufferS, String, int, int),
        put (DirectCharBufferS, char),
        put (DirectCharBufferS, array<char>),
        put (DirectCharBufferS, array<char>, int, int),
        put (DirectCharBufferS, int, char),
        read,
        remaining,
        reset,
        rewind,
        slice,
        subSequence,
        toString (DirectCharBufferS),
        toString (DirectCharBufferS, int, int),
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectCharBufferS, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectCharBufferS): long
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: DirectCharBufferS, csq: CharSequence): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: DirectCharBufferS, csq: CharSequence, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: DirectCharBufferS, c: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.array (@target self: DirectCharBufferS): array<char>
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.arrayOffset (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectCharBufferS): CharBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectCharBufferS): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.charAt (@target self: DirectCharBufferS, index: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.chars (@target self: DirectCharBufferS): IntStream
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectCharBufferS): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectCharBufferS): Buffer
    {
        action TODO();
    }


    // within java.lang.CharSequence
    fun *.codePoints (@target self: DirectCharBufferS): IntStream
    {
        action TODO();
    }


    fun *.compact (@target self: DirectCharBufferS): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.compareTo (@target self: DirectCharBufferS, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectCharBufferS): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.equals (@target self: DirectCharBufferS, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectCharBufferS): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectCharBufferS): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.get (@target self: DirectCharBufferS, dst: array<char>): CharBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectCharBufferS, dst: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectCharBufferS, i: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.hasArray (@target self: DirectCharBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectCharBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.hashCode (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectCharBufferS): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectCharBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.length (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectCharBufferS, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectCharBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.mismatch (@target self: DirectCharBufferS, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectCharBufferS): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectCharBufferS, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferS, src: CharBuffer): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.put (@target self: DirectCharBufferS, src: String): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: DirectCharBufferS, src: String, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferS, x: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @final fun *.put (@target self: DirectCharBufferS, src: array<char>): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferS, src: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectCharBufferS, i: int, x: char): CharBuffer
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    // within java.nio.CharBuffer
    fun *.read (@target self: DirectCharBufferS, _target: CharBuffer): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectCharBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectCharBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectCharBufferS): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectCharBufferS): CharBuffer
    {
        action TODO();
    }


    fun *.subSequence (@target self: DirectCharBufferS, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.toString (@target self: DirectCharBufferS): String
    {
        action TODO();
    }


    fun *.toString (@target self: DirectCharBufferS, start: int, end: int): String
    {
        action TODO();
    }

}