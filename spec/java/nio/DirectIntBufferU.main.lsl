libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectIntBufferU.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/IntBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectIntBufferUAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectIntBufferU
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
        get (DirectIntBufferU),
        get (DirectIntBufferU, int),
        get (DirectIntBufferU, array<int>),
        get (DirectIntBufferU, array<int>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectIntBufferU),
        limit (DirectIntBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectIntBufferU),
        position (DirectIntBufferU, int),
        put (DirectIntBufferU, IntBuffer),
        put (DirectIntBufferU, int),
        put (DirectIntBufferU, int, int),
        put (DirectIntBufferU, array<int>),
        put (DirectIntBufferU, array<int>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: DirectIntBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectIntBufferU): long
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.array (@target self: DirectIntBufferU): array<int>
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.arrayOffset (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectIntBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectIntBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: DirectIntBufferU): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.compareTo (@target self: DirectIntBufferU, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.equals (@target self: DirectIntBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: DirectIntBufferU): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferU, i: int): int
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.get (@target self: DirectIntBufferU, dst: array<int>): IntBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectIntBufferU, dst: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.hasArray (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.hashCode (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectIntBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectIntBufferU, newLimit: int): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: DirectIntBufferU): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.mismatch (@target self: DirectIntBufferU, that: IntBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectIntBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectIntBufferU, newPosition: int): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, src: IntBuffer): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, x: int): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, i: int, x: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    @Phantom @final fun *.put (@target self: DirectIntBufferU, src: array<int>): IntBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectIntBufferU, src: array<int>, offset: int, length: int): IntBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: DirectIntBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: DirectIntBufferU): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: DirectIntBufferU): Buffer
    {
        // #warning: final in IntBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: DirectIntBufferU): IntBuffer
    {
        action TODO();
    }


    // within java.nio.IntBuffer
    fun *.toString (@target self: DirectIntBufferU): String
    {
        action TODO();
    }

}