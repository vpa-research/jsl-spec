libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuffer.java";

// imports

import java.common;
import java/io/_interfaces;
import java/lang/_interfaces;


// local semantic types

@extends("java.lang.AbstractStringBuilder")
@implements("java.io.Serializable")
@implements("java.lang.Comparable")
@implements("java.lang.CharSequence")
@public @final type StringBuffer
    is java.lang.StringBuffer
    for Object
{
    @private @static @final var serialVersionUID: long = 3388685877147921107;
}


// automata

automaton StringBufferAutomaton
(
    var transient: String,
)
: StringBuffer
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        StringBuffer (StringBuffer),
        StringBuffer (StringBuffer, CharSequence),
        StringBuffer (StringBuffer, String),
        StringBuffer (StringBuffer, int),
    ];

    shift Initialized -> self by [
        // instance methods
        append (StringBuffer, CharSequence),
        append (StringBuffer, CharSequence, int, int),
        append (StringBuffer, Object),
        append (StringBuffer, String),
        append (StringBuffer, StringBuffer),
        append (StringBuffer, boolean),
        append (StringBuffer, char),
        append (StringBuffer, array<char>),
        append (StringBuffer, array<char>, int, int),
        append (StringBuffer, double),
        append (StringBuffer, float),
        append (StringBuffer, int),
        append (StringBuffer, long),
        appendCodePoint,
        capacity,
        charAt,
        chars,
        codePointAt,
        codePointBefore,
        codePointCount,
        codePoints,
        compareTo,
        delete,
        deleteCharAt,
        ensureCapacity,
        equals,
        getChars,
        getClass,
        hashCode,
        indexOf (StringBuffer, String),
        indexOf (StringBuffer, String, int),
        insert (StringBuffer, int, CharSequence),
        insert (StringBuffer, int, CharSequence, int, int),
        insert (StringBuffer, int, Object),
        insert (StringBuffer, int, String),
        insert (StringBuffer, int, boolean),
        insert (StringBuffer, int, char),
        insert (StringBuffer, int, array<char>),
        insert (StringBuffer, int, array<char>, int, int),
        insert (StringBuffer, int, double),
        insert (StringBuffer, int, float),
        insert (StringBuffer, int, int),
        insert (StringBuffer, int, long),
        lastIndexOf (StringBuffer, String),
        lastIndexOf (StringBuffer, String, int),
        length,
        notify,
        notifyAll,
        offsetByCodePoints,
        replace,
        reverse,
        setCharAt,
        setLength,
        subSequence,
        substring (StringBuffer, int),
        substring (StringBuffer, int, int),
        toString,
        trimToSize,
        wait (StringBuffer),
        wait (StringBuffer, long),
        wait (StringBuffer, long, int),
    ];

    // internal variables

    // utilities

    // constructors
    @AnnotatedWith("jdk.internal.HotSpotIntrinsicCandidate")
    constructor *.StringBuffer (@target self: StringBuffer)
    {
        result = super(16);
    }


    constructor *.StringBuffer (@target self: StringBuffer, seq: CharSequence)
    {
        action TODO();
    }

    @AnnotatedWith("jdk.internal.HotSpotIntrinsicCandidate")
    constructor *.StringBuffer (@target self: StringBuffer, str: String)
    {
        action TODO();
    }

    @AnnotatedWith("jdk.internal.HotSpotIntrinsicCandidate")
    constructor *.StringBuffer (@target self: StringBuffer, capacity: int)
    {
        action TODO();
    }


    // static methods

    // methods
    @AnnotatedWith("java.lang.Override")
    @synchronized fun *.append (@target self: StringBuffer, s: CharSequence): StringBuffer
    {
        val toStringCache: String = null;
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, s: CharSequence, start: int, end: int): StringBuffer
    {
        action TODO();
    }

    @AnnotatedWith("java.lang.Override")
    @synchronized fun *.append (@target self: StringBuffer, obj: Object): StringBuffer
    {
        action TODO();
    }

    @AnnotatedWith("java.lang.Override")
    @AnnotatedWith("jdk.internal.HotSpotIntrinsicCandidate")
    @synchronized fun *.append (@target self: StringBuffer, str: String): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, sb: StringBuffer): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, b: boolean): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, c: char): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>, offset: int, len: int): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, d: double): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, f: float): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, i: int): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.append (@target self: StringBuffer, lng: long): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.appendCodePoint (@target self: StringBuffer, codePoint: int): StringBuffer
    {
        action TODO();
    }

    @AnnotatedWith("java.lang.Override")
    @synchronized fun *.capacity (@target self: StringBuffer): int
    {
        action TODO();
    }


    @synchronized fun *.charAt (@target self: StringBuffer, index: int): char
    {
        action TODO();
    }


    // within java.lang.AbstractStringBuilder
    fun *.chars (@target self: StringBuffer): IntStream
    {
        action TODO();
    }


    @synchronized fun *.codePointAt (@target self: StringBuffer, index: int): int
    {
        action TODO();
    }


    @synchronized fun *.codePointBefore (@target self: StringBuffer, index: int): int
    {
        action TODO();
    }


    @synchronized fun *.codePointCount (@target self: StringBuffer, beginIndex: int, endIndex: int): int
    {
        action TODO();
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePoints (@target self: StringBuffer): IntStream
    {
        action TODO();
    }

    @AnnotatedWith("java.lang.Override")
    @synchronized fun *.compareTo (@target self: StringBuffer, another: StringBuffer): int
    {
        action TODO();
    }


    @synchronized fun *.delete (@target self: StringBuffer, start: int, end: int): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.deleteCharAt (@target self: StringBuffer, index: int): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.ensureCapacity (@target self: StringBuffer, minimumCapacity: int): void
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.equals (@target self: StringBuffer, obj: Object): boolean
    {
        action TODO();
    }


    @synchronized fun *.getChars (@target self: StringBuffer, srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void
    {
        action TODO();
    }


    // within java.lang.Object
    @final fun *.getClass (@target self: StringBuffer): Class
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.hashCode (@target self: StringBuffer): int
    {
        action TODO();
    }


    fun *.indexOf (@target self: StringBuffer, str: String): int
    {
        action TODO();
    }


    @synchronized fun *.indexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence, start: int, end: int): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.insert (@target self: StringBuffer, offset: int, obj: Object): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.insert (@target self: StringBuffer, offset: int, str: String): StringBuffer
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, offset: int, b: boolean): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.insert (@target self: StringBuffer, offset: int, c: char): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.insert (@target self: StringBuffer, offset: int, str: array<char>): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.insert (@target self: StringBuffer, index: int, str: array<char>, offset: int, len: int): StringBuffer
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, offset: int, d: double): StringBuffer
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, offset: int, f: float): StringBuffer
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, offset: int, i: int): StringBuffer
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, offset: int, l: long): StringBuffer
    {
        action TODO();
    }


    fun *.lastIndexOf (@target self: StringBuffer, str: String): int
    {
        action TODO();
    }


    @synchronized fun *.lastIndexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        action TODO();
    }


    @synchronized fun *.length (@target self: StringBuffer): int
    {
        action TODO();
    }


    // within java.lang.Object
    @final fun *.notify (@target self: StringBuffer): void
    {
        action TODO();
    }


    // within java.lang.Object
    @final fun *.notifyAll (@target self: StringBuffer): void
    {
        action TODO();
    }


    @synchronized fun *.offsetByCodePoints (@target self: StringBuffer, index: int, codePointOffset: int): int
    {
        action TODO();
    }


    @synchronized fun *.replace (@target self: StringBuffer, start: int, end: int, str: String): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.reverse (@target self: StringBuffer): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.setCharAt (@target self: StringBuffer, index: int, ch: char): void
    {
        action TODO();
    }


    @synchronized fun *.setLength (@target self: StringBuffer, newLength: int): void
    {
        action TODO();
    }


    @synchronized fun *.subSequence (@target self: StringBuffer, start: int, end: int): CharSequence
    {
        action TODO();
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int): String
    {
        action TODO();
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int, end: int): String
    {
        action TODO();
    }


    @synchronized fun *.toString (@target self: StringBuffer): String
    {
        action TODO();
    }


    @synchronized fun *.trimToSize (@target self: StringBuffer): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    // within java.lang.Object
    @final fun *.wait (@target self: StringBuffer): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    // within java.lang.Object
    @final fun *.wait (@target self: StringBuffer, arg0: long): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    // within java.lang.Object
    @final fun *.wait (@target self: StringBuffer, timeoutMillis: long, nanos: int): void
    {
        action TODO();
    }

}