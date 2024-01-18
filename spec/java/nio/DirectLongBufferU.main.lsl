libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectLongBufferU.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/LongBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectLongBufferUAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
): LSLDirectLongBufferU
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
        get (DirectLongBufferU),
        get (DirectLongBufferU, int),
        get (DirectLongBufferU, array<long>),
        get (DirectLongBufferU, array<long>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectLongBufferU),
        limit (DirectLongBufferU, int),
        mark,
        mismatch,
        order,
        position (DirectLongBufferU),
        position (DirectLongBufferU, int),
        put (DirectLongBufferU, LongBuffer),
        put (DirectLongBufferU, int, long),
        put (DirectLongBufferU, long),
        put (DirectLongBufferU, array<long>),
        put (DirectLongBufferU, array<long>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: DirectLongBufferU, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectLongBufferU): long
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.array (@target self: DirectLongBufferU): array<long>
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.arrayOffset (@target self: DirectLongBufferU): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectLongBufferU): LongBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectLongBufferU): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: DirectLongBufferU): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectLongBufferU): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: DirectLongBufferU): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: DirectLongBufferU): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.compareTo (@target self: DirectLongBufferU, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectLongBufferU): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.equals (@target self: DirectLongBufferU, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: DirectLongBufferU): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: DirectLongBufferU): long
    {
        action TODO();
    }


    fun *.get (@target self: DirectLongBufferU, i: int): long
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.get (@target self: DirectLongBufferU, dst: array<long>): LongBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectLongBufferU, dst: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.hasArray (@target self: DirectLongBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: DirectLongBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.hashCode (@target self: DirectLongBufferU): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectLongBufferU): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectLongBufferU): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectLongBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectLongBufferU, newLimit: int): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: DirectLongBufferU): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.mismatch (@target self: DirectLongBufferU, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectLongBufferU): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectLongBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectLongBufferU, newPosition: int): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferU, src: LongBuffer): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferU, i: int, x: long): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferU, x: long): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.put (@target self: DirectLongBufferU, src: array<long>): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferU, src: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: DirectLongBufferU): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: DirectLongBufferU): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: DirectLongBufferU): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: DirectLongBufferU): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.toString (@target self: DirectLongBufferU): String
    {
        action TODO();
    }

}