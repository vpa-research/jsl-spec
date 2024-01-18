libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectLongBufferS.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteOrder;
import java/nio/LongBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// automata

automaton DirectLongBufferSAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: LSLDirectLongBufferS
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
        get (DirectLongBufferS),
        get (DirectLongBufferS, int),
        get (DirectLongBufferS, array<long>),
        get (DirectLongBufferS, array<long>, int, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isReadOnly,
        limit (DirectLongBufferS),
        limit (DirectLongBufferS, int),
        mark,
        mismatch,
        order,
        position (DirectLongBufferS),
        position (DirectLongBufferS, int),
        put (DirectLongBufferS, LongBuffer),
        put (DirectLongBufferS, int, long),
        put (DirectLongBufferS, long),
        put (DirectLongBufferS, array<long>),
        put (DirectLongBufferS, array<long>, int, int),
        remaining,
        reset,
        rewind,
        slice,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: DirectLongBufferS, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.address (@target self: DirectLongBufferS): long
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.array (@target self: DirectLongBufferS): array<long>
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.arrayOffset (@target self: DirectLongBufferS): int
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectLongBufferS): LongBuffer
    {
        action TODO();
    }


    fun *.attachment (@target self: DirectLongBufferS): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.capacity (@target self: DirectLongBufferS): int
    {
        action TODO();
    }


    fun *.cleaner (@target self: DirectLongBufferS): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.clear (@target self: DirectLongBufferS): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.compact (@target self: DirectLongBufferS): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.compareTo (@target self: DirectLongBufferS, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectLongBufferS): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.equals (@target self: DirectLongBufferS, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.flip (@target self: DirectLongBufferS): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.get (@target self: DirectLongBufferS): long
    {
        action TODO();
    }


    fun *.get (@target self: DirectLongBufferS, i: int): long
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.get (@target self: DirectLongBufferS, dst: array<long>): LongBuffer
    {
        action TODO();
    }


    fun *.get (@target self: DirectLongBufferS, dst: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.hasArray (@target self: DirectLongBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.hasRemaining (@target self: DirectLongBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.hashCode (@target self: DirectLongBufferS): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectLongBufferS): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectLongBufferS): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectLongBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.limit (@target self: DirectLongBufferS, newLimit: int): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.mark (@target self: DirectLongBufferS): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.mismatch (@target self: DirectLongBufferS, that: LongBuffer): int
    {
        action TODO();
    }


    fun *.order (@target self: DirectLongBufferS): ByteOrder
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectLongBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.position (@target self: DirectLongBufferS, newPosition: int): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferS, src: LongBuffer): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferS, i: int, x: long): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferS, x: long): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    @Phantom @final fun *.put (@target self: DirectLongBufferS, src: array<long>): LongBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectLongBufferS, src: array<long>, offset: int, length: int): LongBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.remaining (@target self: DirectLongBufferS): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.reset (@target self: DirectLongBufferS): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    // within java.nio.Buffer
    @Phantom @final fun *.rewind (@target self: DirectLongBufferS): Buffer
    {
        // #warning: final in LongBuffer, used original method
        action TODO();
    }


    fun *.slice (@target self: DirectLongBufferS): LongBuffer
    {
        action TODO();
    }


    // within java.nio.LongBuffer
    fun *.toString (@target self: DirectLongBufferS): String
    {
        action TODO();
    }

}