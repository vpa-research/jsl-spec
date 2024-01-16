libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectDoubleBufferU.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/DoubleBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectDoubleBufferUAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectDoubleBufferU
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
        get (DirectDoubleBufferU),
        get (DirectDoubleBufferU, array<double>),
        get (DirectDoubleBufferU, array<double>, int, int),
        get (DirectDoubleBufferU, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectDoubleBufferU),
        limit (DirectDoubleBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectDoubleBufferU),
        position (DirectDoubleBufferU, int),
        put (DirectDoubleBufferU, DoubleBuffer),
        put (DirectDoubleBufferU, double),
        put (DirectDoubleBufferU, array<double>),
        put (DirectDoubleBufferU, array<double>, int, int),
        put (DirectDoubleBufferU, int, double),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: DirectDoubleBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectDoubleBufferU): long
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.array (@target self: DirectDoubleBufferU): array<double>
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.arrayOffset (@target self: DirectDoubleBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectDoubleBufferU): DoubleBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectDoubleBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: DirectDoubleBufferU): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectDoubleBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: DirectDoubleBufferU): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: DirectDoubleBufferU): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.compareTo (@target self: DirectDoubleBufferU, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectDoubleBufferU): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.equals (@target self: DirectDoubleBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: DirectDoubleBufferU): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: DirectDoubleBufferU): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.get (@target self: DirectDoubleBufferU, dst: array<double>): DoubleBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectDoubleBufferU, dst: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectDoubleBufferU, i: int): double
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.hasArray (@target self: DirectDoubleBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: DirectDoubleBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.hashCode (@target self: DirectDoubleBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectDoubleBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectDoubleBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectDoubleBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectDoubleBufferU, newLimit: int): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: DirectDoubleBufferU): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.mismatch (@target self: DirectDoubleBufferU, that: DoubleBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectDoubleBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectDoubleBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectDoubleBufferU, newPosition: int): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferU, src: DoubleBuffer): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferU, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    @Phantom @final fun *.put (@target self: DirectDoubleBufferU, src: array<double>): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferU, src: array<double>, offset: int, length: int): DoubleBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectDoubleBufferU, i: int, x: double): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: DirectDoubleBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: DirectDoubleBufferU): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: DirectDoubleBufferU): Buffer
    {
        // #warning: final in DoubleBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: DirectDoubleBufferU): DoubleBuffer
    {
        action TODO();
    }


    // within java.nio.DoubleBuffer
    fun *.toString (@target self: DirectDoubleBufferU): String
    {
        action TODO();
    }

}