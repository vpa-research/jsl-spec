libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectFloatBufferS.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/FloatBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectFloatBufferSAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectFloatBufferS
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
        get (DirectFloatBufferS),
        get (DirectFloatBufferS, array<float>),
        get (DirectFloatBufferS, array<float>, int, int),
        get (DirectFloatBufferS, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectFloatBufferS),
        limit (DirectFloatBufferS, int),
        mark,
        mismatch,
        order,
        position (DirectFloatBufferS),
        position (DirectFloatBufferS, int),
        put (DirectFloatBufferS, FloatBuffer),
        put (DirectFloatBufferS, float),
        put (DirectFloatBufferS, array<float>),
        put (DirectFloatBufferS, array<float>, int, int),
        put (DirectFloatBufferS, int, float),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: DirectFloatBufferS, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectFloatBufferS): long
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.array (@target self: DirectFloatBufferS): array<float>
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.arrayOffset (@target self: DirectFloatBufferS): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectFloatBufferS): FloatBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectFloatBufferS): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectFloatBufferS): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectFloatBufferS): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectFloatBufferS): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectFloatBufferS): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.compareTo (@target self: DirectFloatBufferS, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectFloatBufferS): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.equals (@target self: DirectFloatBufferS, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectFloatBufferS): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectFloatBufferS): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.get (@target self: DirectFloatBufferS, dst: array<float>): FloatBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectFloatBufferS, dst: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectFloatBufferS, i: int): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.hasArray (@target self: DirectFloatBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectFloatBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.hashCode (@target self: DirectFloatBufferS): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectFloatBufferS): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectFloatBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectFloatBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectFloatBufferS, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectFloatBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.mismatch (@target self: DirectFloatBufferS, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectFloatBufferS): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectFloatBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectFloatBufferS, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferS, src: FloatBuffer): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferS, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @final fun *.put (@target self: DirectFloatBufferS, src: array<float>): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferS, src: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferS, i: int, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectFloatBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectFloatBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectFloatBufferS): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectFloatBufferS): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.toString (@target self: DirectFloatBufferS): String
    {
        action TODO();
    }

}