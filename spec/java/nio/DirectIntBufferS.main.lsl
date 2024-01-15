libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectIntBufferS.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/IntBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectIntBufferSAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectIntBufferS
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
        get (DirectIntBufferS),
        get (DirectIntBufferS, int),
        get (DirectIntBufferS, array<int>),
        get (DirectIntBufferS, array<int>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectIntBufferS),
        limit (DirectIntBufferS, int),
        mark,
        mismatch,
        order,
        position (DirectIntBufferS),
        position (DirectIntBufferS, int),
        put (DirectIntBufferS, IntBuffer),
        put (DirectIntBufferS, int),
        put (DirectIntBufferS, int, int),
        put (DirectIntBufferS, array<int>),
        put (DirectIntBufferS, array<int>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectIntBufferS, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectIntBufferS): long
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.array (@target self: DirectIntBufferS): array<int>
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.arrayOffset (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectIntBufferS): IntBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectIntBufferS): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectIntBufferS): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectIntBufferS): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectIntBufferS): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.compareTo (@target self: DirectIntBufferS, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectIntBufferS): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.equals (@target self: DirectIntBufferS, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectIntBufferS): Buffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferS, i: int): int
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: DirectIntBufferS, dst: array<int>): IntBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferS, dst: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.hasArray (@target self: DirectIntBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectIntBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.hashCode (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectIntBufferS): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectIntBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectIntBufferS, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectIntBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.mismatch (@target self: DirectIntBufferS, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectIntBufferS): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectIntBufferS, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferS, src: IntBuffer): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferS, x: int): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferS, i: int, x: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @final fun *.put (@target self: DirectIntBufferS, src: array<int>): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferS, src: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectIntBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectIntBufferS): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectIntBufferS): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectIntBufferS): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.toString (@target self: DirectIntBufferS): String
    {
        action TODO();
    }

}