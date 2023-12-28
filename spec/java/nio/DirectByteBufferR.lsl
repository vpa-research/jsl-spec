libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectByteBufferR.java";

// imports

import java/io/FileDescriptor;
import java/lang/Object;
import java/lang/Runnable;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/nio/DoubleBuffer;
import java/nio/FloatBuffer;
import java/nio/IntBuffer;
import java/nio/LongBuffer;
import java/nio/MappedByteBuffer;
import java/nio/ShortBuffer;
import jdk/internal/ref/Cleaner;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.DirectByteBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public @private type DirectByteBufferR
    is java.nio.DirectByteBufferR
    for Object
{
}


// automata

automaton DirectByteBufferRAutomaton
(
    var att: Object,
    var mark: int,
    var position: int,
    var limit: int,
    var capacity: int,
    var offset: int
)
: DirectByteBufferR
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (DirectByteBufferR, DirectBuffer, int, int, int, int, int),
        `<init>` (DirectByteBufferR, int),
        `<init>` (DirectByteBufferR, int, long, FileDescriptor, Runnable),
    ];

    shift Initialized -> self by [
        // instance methods
        address,
        alignedSlice,
        alignmentOffset,
        array,
        arrayOffset,
        asCharBuffer,
        asDoubleBuffer,
        asFloatBuffer,
        asIntBuffer,
        asLongBuffer,
        asReadOnlyBuffer,
        asShortBuffer,
        attachment,
        capacity,
        cleaner,
        clear,
        compact,
        compareTo,
        duplicate,
        equals,
        flip,
        force,
        get (DirectByteBufferR),
        get (DirectByteBufferR, array<byte>),
        get (DirectByteBufferR, array<byte>, int, int),
        get (DirectByteBufferR, int),
        getChar (DirectByteBufferR),
        getChar (DirectByteBufferR, int),
        getDouble (DirectByteBufferR),
        getDouble (DirectByteBufferR, int),
        getFloat (DirectByteBufferR),
        getFloat (DirectByteBufferR, int),
        getInt (DirectByteBufferR),
        getInt (DirectByteBufferR, int),
        getLong (DirectByteBufferR),
        getLong (DirectByteBufferR, int),
        getShort (DirectByteBufferR),
        getShort (DirectByteBufferR, int),
        hasArray,
        hasRemaining,
        hashCode,
        isDirect,
        isLoaded,
        isReadOnly,
        limit (DirectByteBufferR),
        limit (DirectByteBufferR, int),
        load,
        mark,
        mismatch,
        order (DirectByteBufferR),
        order (DirectByteBufferR, ByteOrder),
        position (DirectByteBufferR),
        position (DirectByteBufferR, int),
        put (DirectByteBufferR, ByteBuffer),
        put (DirectByteBufferR, byte),
        put (DirectByteBufferR, array<byte>),
        put (DirectByteBufferR, array<byte>, int, int),
        put (DirectByteBufferR, int, byte),
        putChar (DirectByteBufferR, char),
        putChar (DirectByteBufferR, int, char),
        putDouble (DirectByteBufferR, double),
        putDouble (DirectByteBufferR, int, double),
        putFloat (DirectByteBufferR, float),
        putFloat (DirectByteBufferR, int, float),
        putInt (DirectByteBufferR, int),
        putInt (DirectByteBufferR, int, int),
        putLong (DirectByteBufferR, int, long),
        putLong (DirectByteBufferR, long),
        putShort (DirectByteBufferR, int, short),
        putShort (DirectByteBufferR, short),
        remaining,
        reset,
        rewind,
        slice (DirectByteBufferR),
        slice (DirectByteBufferR, int, int),
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: DirectByteBufferR, db: DirectBuffer, mark: int, pos: int, lim: int, cap: int, off: int)
    {
        action TODO();
    }


    @private constructor *.`<init>` (@target self: DirectByteBufferR, cap: int)
    {
        action TODO();
    }


    @protected constructor *.`<init>` (@target self: DirectByteBufferR, cap: int, addr: long, fd: FileDescriptor, unmapper: Runnable)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.nio.DirectByteBuffer
    fun *.address (@target self: DirectByteBufferR): long
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.alignedSlice (@target self: DirectByteBufferR, unitSize: int): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.alignmentOffset (@target self: DirectByteBufferR, index: int, unitSize: int): int
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.array (@target self: DirectByteBufferR): array<byte>
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.arrayOffset (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    fun *.asCharBuffer (@target self: DirectByteBufferR): CharBuffer
    {
        action TODO();
    }


    fun *.asDoubleBuffer (@target self: DirectByteBufferR): DoubleBuffer
    {
        action TODO();
    }


    fun *.asFloatBuffer (@target self: DirectByteBufferR): FloatBuffer
    {
        action TODO();
    }


    fun *.asIntBuffer (@target self: DirectByteBufferR): IntBuffer
    {
        action TODO();
    }


    fun *.asLongBuffer (@target self: DirectByteBufferR): LongBuffer
    {
        action TODO();
    }


    fun *.asReadOnlyBuffer (@target self: DirectByteBufferR): ByteBuffer
    {
        action TODO();
    }


    fun *.asShortBuffer (@target self: DirectByteBufferR): ShortBuffer
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.attachment (@target self: DirectByteBufferR): Object
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.capacity (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.cleaner (@target self: DirectByteBufferR): Cleaner
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.clear (@target self: DirectByteBufferR): Buffer
    {
        action TODO();
    }


    fun *.compact (@target self: DirectByteBufferR): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.compareTo (@target self: DirectByteBufferR, that: ByteBuffer): int
    {
        action TODO();
    }


    fun *.duplicate (@target self: DirectByteBufferR): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.equals (@target self: DirectByteBufferR, ob: Object): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.flip (@target self: DirectByteBufferR): Buffer
    {
        action TODO();
    }


    // within java.nio.MappedByteBuffer
    @final fun *.force (@target self: DirectByteBufferR): MappedByteBuffer
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.get (@target self: DirectByteBufferR): byte
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.get (@target self: DirectByteBufferR, dst: array<byte>): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.get (@target self: DirectByteBufferR, dst: array<byte>, offset: int, length: int): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.get (@target self: DirectByteBufferR, i: int): byte
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getChar (@target self: DirectByteBufferR): char
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getChar (@target self: DirectByteBufferR, i: int): char
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getDouble (@target self: DirectByteBufferR): double
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getDouble (@target self: DirectByteBufferR, i: int): double
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getFloat (@target self: DirectByteBufferR): float
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getFloat (@target self: DirectByteBufferR, i: int): float
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getInt (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getInt (@target self: DirectByteBufferR, i: int): int
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getLong (@target self: DirectByteBufferR): long
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getLong (@target self: DirectByteBufferR, i: int): long
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getShort (@target self: DirectByteBufferR): short
    {
        action TODO();
    }


    // within java.nio.DirectByteBuffer
    fun *.getShort (@target self: DirectByteBufferR, i: int): short
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.hasArray (@target self: DirectByteBufferR): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.hasRemaining (@target self: DirectByteBufferR): boolean
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.hashCode (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    fun *.isDirect (@target self: DirectByteBufferR): boolean
    {
        action TODO();
    }


    // within java.nio.MappedByteBuffer
    @final fun *.isLoaded (@target self: DirectByteBufferR): boolean
    {
        action TODO();
    }


    fun *.isReadOnly (@target self: DirectByteBufferR): boolean
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.limit (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.limit (@target self: DirectByteBufferR, newLimit: int): Buffer
    {
        action TODO();
    }


    // within java.nio.MappedByteBuffer
    @final fun *.load (@target self: DirectByteBufferR): MappedByteBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.mark (@target self: DirectByteBufferR): Buffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.mismatch (@target self: DirectByteBufferR, that: ByteBuffer): int
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.order (@target self: DirectByteBufferR): ByteOrder
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.order (@target self: DirectByteBufferR, bo: ByteOrder): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.position (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.position (@target self: DirectByteBufferR, newPosition: int): Buffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectByteBufferR, src: ByteBuffer): ByteBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectByteBufferR, x: byte): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    @final fun *.put (@target self: DirectByteBufferR, src: array<byte>): ByteBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectByteBufferR, src: array<byte>, offset: int, length: int): ByteBuffer
    {
        action TODO();
    }


    fun *.put (@target self: DirectByteBufferR, i: int, x: byte): ByteBuffer
    {
        action TODO();
    }


    fun *.putChar (@target self: DirectByteBufferR, x: char): ByteBuffer
    {
        action TODO();
    }


    fun *.putChar (@target self: DirectByteBufferR, i: int, x: char): ByteBuffer
    {
        action TODO();
    }


    fun *.putDouble (@target self: DirectByteBufferR, x: double): ByteBuffer
    {
        action TODO();
    }


    fun *.putDouble (@target self: DirectByteBufferR, i: int, x: double): ByteBuffer
    {
        action TODO();
    }


    fun *.putFloat (@target self: DirectByteBufferR, x: float): ByteBuffer
    {
        action TODO();
    }


    fun *.putFloat (@target self: DirectByteBufferR, i: int, x: float): ByteBuffer
    {
        action TODO();
    }


    fun *.putInt (@target self: DirectByteBufferR, x: int): ByteBuffer
    {
        action TODO();
    }


    fun *.putInt (@target self: DirectByteBufferR, i: int, x: int): ByteBuffer
    {
        action TODO();
    }


    fun *.putLong (@target self: DirectByteBufferR, i: int, x: long): ByteBuffer
    {
        action TODO();
    }


    fun *.putLong (@target self: DirectByteBufferR, x: long): ByteBuffer
    {
        action TODO();
    }


    fun *.putShort (@target self: DirectByteBufferR, i: int, x: short): ByteBuffer
    {
        action TODO();
    }


    fun *.putShort (@target self: DirectByteBufferR, x: short): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    @final fun *.remaining (@target self: DirectByteBufferR): int
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.reset (@target self: DirectByteBufferR): Buffer
    {
        action TODO();
    }


    // within java.nio.Buffer
    fun *.rewind (@target self: DirectByteBufferR): Buffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectByteBufferR): ByteBuffer
    {
        action TODO();
    }


    fun *.slice (@target self: DirectByteBufferR, pos: int, lim: int): ByteBuffer
    {
        action TODO();
    }


    // within java.nio.ByteBuffer
    fun *.toString (@target self: DirectByteBufferR): String
    {
        action TODO();
    }

}