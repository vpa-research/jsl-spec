libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java.common;
import java/lang/StringBuffer;
import java/lang/_interfaces;


// local semantic types

@extends("java.lang.AbstractStringBuilder")
@implements("java.io.Serializable")
@implements("java.lang.Comparable")
@implements("java.lang.CharSequence")
@public @final type StringBuilder
    is java.lang.StringBuilder
    for Object
{
    //@private @static @final var serialVersionUID: long = 4383685877147921099;
}


// automata

automaton StringBuilderAutomaton
(
)
: StringBuilder
{

    var storage: array<byte>;
    var length: int;
    // Problem
    // How can we get this value from "java.lang.String" ?
    val coder: byte;

    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        StringBuilder (StringBuilder),
        StringBuilder (StringBuilder, CharSequence),
        StringBuilder (StringBuilder, String),
        StringBuilder (StringBuilder, int),
    ];

    shift Initialized -> self by [
        // instance methods
        append (StringBuilder, CharSequence),
        append (StringBuilder, CharSequence, int, int),
        append (StringBuilder, Object),
        append (StringBuilder, String),
        append (StringBuilder, StringBuffer),
        append (StringBuilder, boolean),
        append (StringBuilder, char),
        append (StringBuilder, array<char>),
        append (StringBuilder, array<char>, int, int),
        append (StringBuilder, double),
        append (StringBuilder, float),
        append (StringBuilder, int),
        append (StringBuilder, long),
        appendCodePoint,
        compareTo,
        delete,
        deleteCharAt,
        indexOf (StringBuilder, String),
        indexOf (StringBuilder, String, int),
        insert (StringBuilder, int, CharSequence),
        insert (StringBuilder, int, CharSequence, int, int),
        insert (StringBuilder, int, Object),
        insert (StringBuilder, int, String),
        insert (StringBuilder, int, boolean),
        insert (StringBuilder, int, char),
        insert (StringBuilder, int, array<char>),
        insert (StringBuilder, int, array<char>, int, int),
        insert (StringBuilder, int, double),
        insert (StringBuilder, int, float),
        insert (StringBuilder, int, int),
        insert (StringBuilder, int, long),
        lastIndexOf (StringBuilder, String),
        lastIndexOf (StringBuilder, String, int),
        replace,
        reverse,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.StringBuilder (@target self: StringBuilder)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length == 16;
        // Can we give type = "byte" in ARRAY_NEW action ?
        this.storage = action ARRAY_NEW("java.lang.Byte", 16);
        this.length = 16;
    }


    constructor *.StringBuilder (@target self: StringBuilder, seq: CharSequence)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 16;

        val seqLength: Iterator = action CALL_METHOD(seq, "length", []);
        val newLength = seqLength + 16;

        // Can we give type = "byte" in ARRAY_NEW action ?
        this.storage = action ARRAY_NEW("java.lang.Byte", newLength);
        this.length = newLength;
        _append(seq);
    }


    constructor *.StringBuilder (@target self: StringBuilder, str: String)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 0;

        // Problem:
        // How do we can get str.length ?

        // Can we give type = "byte" in ARRAY_NEW action ?
        this.storage = action ARRAY_NEW("java.lang.Byte", capacity);
        this.length = capacity;
        _append(str);
    }


    constructor *.StringBuilder (@target self: StringBuilder, capacity: int)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length == capacity;
        // Can we give type = "byte" in ARRAY_NEW action ?
        this.storage = action ARRAY_NEW("java.lang.Byte", capacity);
        this.length = capacity;
    }


    // static methods


    // utilities

    proc _append (seq: CharSequence): void
    {
        action TODO();
        /*if (seq == null)
        {

        }*/
    }

    proc _append (str: String): void
    {
        action TODO();
    }


    // methods

    fun *.append (@target self: StringBuilder, s: CharSequence): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, s: CharSequence, start: int, end: int): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, obj: Object): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, str: String): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, sb: StringBuffer): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, b: boolean): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, c: char): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, str: array<char>): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, str: array<char>, offset: int, len: int): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, d: double): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, f: float): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, i: int): StringBuilder
    {
        action TODO();
    }


    fun *.append (@target self: StringBuilder, lng: long): StringBuilder
    {
        action TODO();
    }


    fun *.appendCodePoint (@target self: StringBuilder, codePoint: int): StringBuilder
    {
        action TODO();
    }


    fun *.compareTo (@target self: StringBuilder, another: StringBuilder): int
    {
        action TODO();
    }


    fun *.delete (@target self: StringBuilder, start: int, end: int): StringBuilder
    {
        action TODO();
    }


    fun *.deleteCharAt (@target self: StringBuilder, index: int): StringBuilder
    {
        action TODO();
    }


    fun *.indexOf (@target self: StringBuilder, str: String): int
    {
        action TODO();
    }


    fun *.indexOf (@target self: StringBuilder, str: String, fromIndex: int): int
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, s: CharSequence): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, s: CharSequence, start: int, end: int): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, obj: Object): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, str: String): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, b: boolean): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, c: char): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, str: array<char>): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, index: int, str: array<char>, offset: int, len: int): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, d: double): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, f: float): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, i: int): StringBuilder
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuilder, offset: int, l: long): StringBuilder
    {
        action TODO();
    }


    fun *.lastIndexOf (@target self: StringBuilder, str: String): int
    {
        action TODO();
    }


    fun *.lastIndexOf (@target self: StringBuilder, str: String, fromIndex: int): int
    {
        action TODO();
    }


    fun *.replace (@target self: StringBuilder, start: int, end: int, str: String): StringBuilder
    {
        action TODO();
    }


    fun *.reverse (@target self: StringBuilder): StringBuilder
    {
        action TODO();
    }


    fun *.toString (@target self: StringBuilder): String
    {
        action TODO();
    }

}