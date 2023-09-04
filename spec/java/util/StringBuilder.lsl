///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java.common;
//import java/lang/StringBuffer;
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


@extends("java.lang.AbstractStringBuilder")
@implements("java.io.Serializable")
@implements("java.lang.Comparable")
@implements("java.lang.CharSequence")
@public @final type StringBuffer
    is java.lang.StringBuffer
    for Object
{
    //@private @static @final var serialVersionUID: long = 3388685877147921107;
}


// === CONSTANTS ===


// automata

automaton StringBuilderAutomaton
(
)
: StringBuilder
{

    var storage: String;
    var length: int;

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

    }


    constructor *.StringBuilder (@target self: StringBuilder, seq: CharSequence)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 0;

        if (seq == null)
        {
            this.storage = "null";
            this.length = 4;
        }
        else
        {
            val seqLength: int = action CALL_METHOD(seq, "length", []);
            this.length = seqLength;

            var i: int = 0;
            action LOOP_FOR(i, 0, seqLength, +1, _appendCharSequence_loop(i, seq));
        }
    }


    @Phantom proc _appendCharSequence_loop(i: int, seq: CharSequence): void
    {
        var currentChar: char = action CALL_METHOD(seq, "charAt", [i]);
        this.storage += action OBJECT_TO_STRING(currentChar);
    }


    constructor *.StringBuilder (@target self: StringBuilder, str: String)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 0;

        if (str == null)
        {
            this.storage = "null";
            this.length = 4;
        }
        else
        {
            val strLength: int = action CALL_METHOD(str, "length", []);
            this.length = strLength;
            this.storage = str;
        }
    }


    constructor *.StringBuilder (@target self: StringBuilder, capacity: int)
    {

    }


    // static methods


    // utilities

    proc _checkRange (start: int, end: int, len: int): void
    {
        if (start < 0 || start > end || end > len)
        {
            val message: String = "start " + action OBJECT_TO_STRING(start) + ", end " + action OBJECT_TO_STRING(end) + ", length " + action OBJECT_TO_STRING(len);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _checkRangeSIOOBE (start: int, end: int, len: int): void
    {
        if (start < 0 || start > end || end > len)
        {
            val message: String = "start " + action OBJECT_TO_STRING(start) + ", end " + action OBJECT_TO_STRING(end) + ", length " + action OBJECT_TO_STRING(len);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [message]);
        }
    }


    proc _checkIndex (index: int): void
    {
         if (index < 0 || index >= this.length)
         {
             val message: String = "index " + action OBJECT_TO_STRING(index) + ",length " + action OBJECT_TO_STRING(this.length);
             action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [message]);
         }
    }


    // methods

    fun *.append (@target self: StringBuilder, seq: CharSequence): StringBuilder
    {
        if (seq == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            val seqLength: int = action CALL_METHOD(seq, "length", []);
            this.length += seqLength;

            var i: int = 0;
            action LOOP_FOR(i, 0, seqLength, +1, _appendCharSequence_loop(i, seq));
        }
        result = self;
    }


    fun *.append (@target self: StringBuilder, seq: CharSequence, start: int, end: int): StringBuilder
    {
        if (seq == null)
            seq = "null";
        val seqLength: int = action CALL_METHOD(seq, "length", []);
        _checkRange(start, end, seqLength);
        this.length += end - start;
        var i: int = 0;
        action LOOP_FOR(i, start, end, +1, _appendCharSequenceRange_loop(i, seq));
        result = self;
    }


    @Phantom proc _appendCharSequenceRange_loop(i: int, seq: CharSequence): void
    {
        var currentChar: char = action CALL_METHOD(seq, "charAt", [i]);
        this.storage += action OBJECT_TO_STRING(currentChar);
    }


    fun *.append (@target self: StringBuilder, obj: Object): StringBuilder
    {
        if (obj == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            // Problem !
            //That's right ? In original: "obj.toString()"
            this.storage += action OBJECT_TO_STRING(obj);
            this.length = action CALL_METHOD(this.storage, "length", []);
        }
        result = self;
    }


    fun *.append (@target self: StringBuilder, str: String): StringBuilder
    {
        if (str == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            this.storage += str;
            this.length = action CALL_METHOD(this.storage, "length", []);
        }
        result = self;
    }


    fun *.append (@target self: StringBuilder, sb: StringBuffer): StringBuilder
    {
        if (sb == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            // That's right for StringBuffer ?
            this.storage += action OBJECT_TO_STRING(sb);
            this.length = action CALL_METHOD(this.storage, "length", []);
        }
        result = self;
    }


    fun *.append (@target self: StringBuilder, b: boolean): StringBuilder
    {
        if (b)
        {
            this.storage += "true";
            this.length += 4;
        }
        else
        {
            this.storage += "false";
            this.length += 5;
        }
        result = self;
    }


    fun *.append (@target self: StringBuilder, c: char): StringBuilder
    {
        // That's right for char ?
        this.storage += action OBJECT_TO_STRING(c);
        this.length += 1;
        result = self;
    }


    fun *.append (@target self: StringBuilder, str: array<char>): StringBuilder
    {
        val strSize: int = action ARRAY_SIZE(str);
        this.length += strSize;
        var i: int = 0;
        action LOOP_FOR(i, 0, strSize, +1, _appendCharsArray_loop(i, str));
        result = self;
    }


    @Phantom proc _appendCharsArray_loop(i: int, str: array<char>): void
    {
        var currentChar: char = str[i];
        this.storage += action OBJECT_TO_STRING(currentChar);
    }


    fun *.append (@target self: StringBuilder, str: array<char>, offset: int, len: int): StringBuilder
    {
        val end: int = offset + len;
        val strSize: int = action ARRAY_SIZE(str);
        _checkRange(offset, end, strSize);
        var i: int = 0;
        action LOOP_FOR(i, 0, strSize, +1, _appendCharsArray_loop(i, str));
        result = self;
    }


    fun *.append (@target self: StringBuilder, d: double): StringBuilder
    {
        this.storage += action OBJECT_TO_STRING(d);
        this.length += 1;
        result = self;
    }


    fun *.append (@target self: StringBuilder, f: float): StringBuilder
    {
        this.storage += action OBJECT_TO_STRING(f);
        this.length += 1;
        result = self;
    }


    fun *.append (@target self: StringBuilder, i: int): StringBuilder
    {
        this.storage += action OBJECT_TO_STRING(i);
        this.length += 1;
        result = self;
    }


    fun *.append (@target self: StringBuilder, lng: long): StringBuilder
    {
        this.storage += action OBJECT_TO_STRING(lng);
        this.length += 1;
        result = self;
    }


    fun *.appendCodePoint (@target self: StringBuilder, codePoint: int): StringBuilder
    {
        action TODO();
        /*if (codePoint >>> 16 == 0)
        {

        }
        else
        {

        }*/
    }


    fun *.compareTo (@target self: StringBuilder, another: StringBuilder): int
    {
        if (another == self)
        {
            result = 0;
        }
        val anotherString: String = action OBJECT_TO_STRING(another);
        // Problem
        //result = action CALL_METHOD(this.storage, "compareTo", [anotherString]);
    }


    fun *.delete (@target self: StringBuilder, start: int, end: int): StringBuilder
    {
        if (end > this.length)
            end = this.length;

        _checkRangeSIOOBE(start, end, this.length);

        val len: int = end - start;

        // Problem with calling method "substring"
        //if (len > 0)
            //this.storage = action CALL_METHOD(this.storage, "substring", [start]);
        result = self;
    }


    fun *.deleteCharAt (@target self: StringBuilder, index: int): StringBuilder
    {
        _checkIndex(index);
        var newString: String = "";
        var i: int = 0;
        action LOOP_FOR(i, 0, this.length, +1, _deleteCharAt_loop(i, index, newString));
        this.storage = newString;
        this.length -= 1;
        result = self;
    }


    @Phantom proc _deleteCharAt_loop(i: int, index: int, newString: String): void
    {
        if (i != index)
        {
            val currentChar: char = action CALL_METHOD(this.storage, "charAt", [i]);
            newString += action OBJECT_TO_STRING(currentChar);
        }
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