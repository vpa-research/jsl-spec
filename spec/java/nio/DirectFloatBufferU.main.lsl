libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectFloatBufferU.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/FloatBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectFloatBufferUAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectFloatBufferU
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
        get (DirectFloatBufferU),
        get (DirectFloatBufferU, array<float>),
        get (DirectFloatBufferU, array<float>, int, int),
        get (DirectFloatBufferU, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectFloatBufferU),
        limit (DirectFloatBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectFloatBufferU),
        position (DirectFloatBufferU, int),
        put (DirectFloatBufferU, FloatBuffer),
        put (DirectFloatBufferU, float),
        put (DirectFloatBufferU, array<float>),
        put (DirectFloatBufferU, array<float>, int, int),
        put (DirectFloatBufferU, int, float),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: DirectFloatBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectFloatBufferU): long
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @Phantom @final fun *.array (@target self: DirectFloatBufferU): array<float>
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @Phantom @final fun *.arrayOffset (@target self: DirectFloatBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectFloatBufferU): FloatBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectFloatBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: DirectFloatBufferU): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectFloatBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: DirectFloatBufferU): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: DirectFloatBufferU): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.compareTo (@target self: DirectFloatBufferU, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectFloatBufferU): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.equals (@target self: DirectFloatBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: DirectFloatBufferU): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: DirectFloatBufferU): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.get (@target self: DirectFloatBufferU, dst: array<float>): FloatBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectFloatBufferU, dst: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectFloatBufferU, i: int): float
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @Phantom @final fun *.hasArray (@target self: DirectFloatBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: DirectFloatBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.hashCode (@target self: DirectFloatBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectFloatBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectFloatBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectFloatBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectFloatBufferU, newLimit: int): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: DirectFloatBufferU): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.mismatch (@target self: DirectFloatBufferU, that: FloatBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectFloatBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectFloatBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectFloatBufferU, newPosition: int): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferU, src: FloatBuffer): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferU, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    @Phantom @final fun *.put (@target self: DirectFloatBufferU, src: array<float>): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferU, src: array<float>, offset: int, length: int): FloatBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectFloatBufferU, i: int, x: float): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: DirectFloatBufferU): int
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: DirectFloatBufferU): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: DirectFloatBufferU): Buffer
    {
        // #warning: final in FloatBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: DirectFloatBufferU): FloatBuffer
    {
        action TODO();
    }


    // within java.nio.FloatBuffer
    fun *.toString (@target self: DirectFloatBufferU): String
    {
        action TODO();
    }

}