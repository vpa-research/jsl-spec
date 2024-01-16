libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsCharBufferB.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/util/stream/IntStream;

// automata

automaton ByteBufferAsCharBufferBAutomaton
(
    var bb: ByteBuffer,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var address: long
)
: LSLByteBufferAsCharBufferB
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ByteBufferAsCharBufferB, ByteBuffer),
        `<init>` (ByteBufferAsCharBufferB, ByteBuffer, int, int, int, int, long),
    ];

    shift Initialized -> self by [
        // instance methods
        append (ByteBufferAsCharBufferB, CharSequence),
        append (ByteBufferAsCharBufferB, CharSequence, int, int),
        append (ByteBufferAsCharBufferB, char),
        array,
        arrayOffset,
        asReadOnlyBuffer,
        capacity,
        charAt,
        chars,
        charRegionOrder,
        clear,
        codePoints,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        get (ByteBufferAsCharBufferB),
        get (ByteBufferAsCharBufferB, array<char>),
        get (ByteBufferAsCharBufferB, array<char>, int, int),
        get (ByteBufferAsCharBufferB, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        length,
        limit (ByteBufferAsCharBufferB),
        limit (ByteBufferAsCharBufferB, int),
        mark,
        mismatch,
        order,
        position (ByteBufferAsCharBufferB),
        position (ByteBufferAsCharBufferB, int),
        put (ByteBufferAsCharBufferB, CharBuffer),
        put (ByteBufferAsCharBufferB, String),
        put (ByteBufferAsCharBufferB, String, int, int),
        put (ByteBufferAsCharBufferB, char),
        put (ByteBufferAsCharBufferB, array<char>),
        put (ByteBufferAsCharBufferB, array<char>, int, int),
        put (ByteBufferAsCharBufferB, int, char),
        read,
        remaining,
        reset,
        rewind,
        slice,
        subSequence,
        toString (ByteBufferAsCharBufferB),
        toString (ByteBufferAsCharBufferB, int, int),
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: ByteBufferAsCharBufferB, bb: ByteBuffer)
    {
        action TODO();
    }


    constructor *.`<init>` (@target self: ByteBufferAsCharBufferB, bb: ByteBuffer, mark: int, pos: int, lim: int, cap: int, addr: long)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.CharBuffer
    fun *.append (@target self: ByteBufferAsCharBufferB, csq: CharSequence): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: ByteBufferAsCharBufferB, csq: CharSequence, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.append (@target self: ByteBufferAsCharBufferB, c: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.array (@target self: ByteBufferAsCharBufferB): array<char>
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.arrayOffset (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: ByteBufferAsCharBufferB): CharBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.charAt (@target self: ByteBufferAsCharBufferB, index: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.charRegionOrder (@target self: ByteBufferAsCharBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.chars (@target self: ByteBufferAsCharBufferB): IntStream
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: ByteBufferAsCharBufferB): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    // within java.lang.CharSequence
    fun *.codePoints (@target self: ByteBufferAsCharBufferB): IntStream
    {
        action TODO();
    }


    fun *.compact (@target self: ByteBufferAsCharBufferB): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.compareTo (@target self: ByteBufferAsCharBufferB, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: ByteBufferAsCharBufferB): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.equals (@target self: ByteBufferAsCharBufferB, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: ByteBufferAsCharBufferB): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsCharBufferB): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.get (@target self: ByteBufferAsCharBufferB, dst: array<char>): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.get (@target self: ByteBufferAsCharBufferB, dst: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.get (@target self: ByteBufferAsCharBufferB, i: int): char
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.hasArray (@target self: ByteBufferAsCharBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: ByteBufferAsCharBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.hashCode (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: ByteBufferAsCharBufferB): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: ByteBufferAsCharBufferB): boolean
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.length (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: ByteBufferAsCharBufferB, newLimit: int): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: ByteBufferAsCharBufferB): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.mismatch (@target self: ByteBufferAsCharBufferB, that: CharBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: ByteBufferAsCharBufferB): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: ByteBufferAsCharBufferB, newPosition: int): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: ByteBufferAsCharBufferB, src: CharBuffer): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.put (@target self: ByteBufferAsCharBufferB, src: String): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: ByteBufferAsCharBufferB, src: String, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsCharBufferB, x: char): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    @Phantom @final fun *.put (@target self: ByteBufferAsCharBufferB, src: array<char>): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.put (@target self: ByteBufferAsCharBufferB, src: array<char>, offset: int, length: int): CharBuffer
    {
        action TODO();
    }


    fun *.put (@target self: ByteBufferAsCharBufferB, i: int, x: char): CharBuffer
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    // within java.nio.CharBuffer
    fun *.read (@target self: ByteBufferAsCharBufferB, _target: CharBuffer): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: ByteBufferAsCharBufferB): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: ByteBufferAsCharBufferB): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: ByteBufferAsCharBufferB): Buffer
    {
        // #warning: final in CharBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: ByteBufferAsCharBufferB): CharBuffer
    {
        action TODO();
    }


    fun *.subSequence (@target self: ByteBufferAsCharBufferB, start: int, end: int): CharBuffer
    {
        action TODO();
    }


    // within java.nio.CharBuffer
    fun *.toString (@target self: ByteBufferAsCharBufferB): String
    {
        action TODO();
    }


    fun *.toString (@target self: ByteBufferAsCharBufferB, start: int, end: int): String
    {
        action TODO();
    }

}
