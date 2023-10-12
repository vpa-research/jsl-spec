//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/PrintStream.java";

// imports

import java.common;
import java/io/File;
import java/io/FilterOutputStream;
import java/io/_interfaces;
import java/lang/_interfaces;
import java/nio/charset/_interfaces;
import java/util/Locale;


// local semantic types

@extends("java.io.FilterOutputStream")
@implements("java.lang.Appendable")
@implements("java.io.Closeable")
@public type PrintStream
    is java.io.PrintStream
    for Object
{
}


// automata

automaton PrintStreamAutomaton
(
)
: PrintStream
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        PrintStream (PrintStream, File),
        PrintStream (PrintStream, File, Charset),
        PrintStream (PrintStream, File, String),
        PrintStream (PrintStream, OutputStream),
        PrintStream (PrintStream, OutputStream, boolean),
        PrintStream (PrintStream, OutputStream, boolean, Charset),
        PrintStream (PrintStream, OutputStream, boolean, String),
        PrintStream (PrintStream, String),
        PrintStream (PrintStream, String, Charset),
        PrintStream (PrintStream, String, String),
        PrintStream (PrintStream, boolean, Charset, OutputStream),
        PrintStream (PrintStream, boolean, OutputStream),
    ];

    shift Initialized -> self by [
        // instance methods
        append (PrintStream, CharSequence),
        append (PrintStream, CharSequence, int, int),
        append (PrintStream, char),
        checkError,
        close,
        flush,
        format (PrintStream, Locale, String, array<Object>),
        format (PrintStream, String, array<Object>),
        print (PrintStream, Object),
        print (PrintStream, String),
        print (PrintStream, boolean),
        print (PrintStream, char),
        print (PrintStream, array<char>),
        print (PrintStream, double),
        print (PrintStream, float),
        print (PrintStream, int),
        print (PrintStream, long),
        printf (PrintStream, Locale, String, array<Object>),
        printf (PrintStream, String, array<Object>),
        println (PrintStream),
        println (PrintStream, Object),
        println (PrintStream, String),
        println (PrintStream, boolean),
        println (PrintStream, char),
        println (PrintStream, array<char>),
        println (PrintStream, double),
        println (PrintStream, float),
        println (PrintStream, int),
        println (PrintStream, long),
        write (PrintStream, array<byte>),
        write (PrintStream, array<byte>, int, int),
        write (PrintStream, int),
    ];

    // internal variables

    // utilities

    // constructors

    @throws(["java.io.FileNotFoundException"])
    constructor *.PrintStream (@target self: PrintStream, file: File)
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    constructor *.PrintStream (@target self: PrintStream, file: File, charset: Charset)
    {
        action TODO();
    }


    @throws(["java.io.FileNotFoundException", "java.io.UnsupportedEncodingException"])
    constructor *.PrintStream (@target self: PrintStream, file: File, csn: String)
    {
        action TODO();
    }


    constructor *.PrintStream (@target self: PrintStream, out: OutputStream)
    {
        action TODO();
    }


    constructor *.PrintStream (@target self: PrintStream, out: OutputStream, autoFlush: boolean)
    {
        action TODO();
    }


    constructor *.PrintStream (@target self: PrintStream, out: OutputStream, autoFlush: boolean, charset: Charset)
    {
        action TODO();
    }


    @throws(["java.io.UnsupportedEncodingException"])
    constructor *.PrintStream (@target self: PrintStream, out: OutputStream, autoFlush: boolean, encoding: String)
    {
        action TODO();
    }


    @throws(["java.io.FileNotFoundException"])
    constructor *.PrintStream (@target self: PrintStream, fileName: String)
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    constructor *.PrintStream (@target self: PrintStream, fileName: String, charset: Charset)
    {
        action TODO();
    }


    @throws(["java.io.FileNotFoundException", "java.io.UnsupportedEncodingException"])
    constructor *.PrintStream (@target self: PrintStream, fileName: String, csn: String)
    {
        action TODO();
    }


    @private constructor *.PrintStream (@target self: PrintStream, autoFlush: boolean, charset: Charset, out: OutputStream)
    {
        action TODO();
    }


    @private constructor *.PrintStream (@target self: PrintStream, autoFlush: boolean, out: OutputStream)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.append (@target self: PrintStream, csq: CharSequence): PrintStream
    {
        action TODO();
    }


    fun *.append (@target self: PrintStream, csq: CharSequence, start: int, end: int): PrintStream
    {
        action TODO();
    }


    fun *.append (@target self: PrintStream, c: char): PrintStream
    {
        action TODO();
    }


    fun *.checkError (@target self: PrintStream): boolean
    {
        action TODO();
    }


    fun *.close (@target self: PrintStream): void
    {
        action TODO();
    }


    fun *.flush (@target self: PrintStream): void
    {
        action TODO();
    }


    @varargs fun *.format (@target self: PrintStream, l: Locale, format: String, args: array<Object>): PrintStream
    {
        action TODO();
    }


    @varargs fun *.format (@target self: PrintStream, format: String, args: array<Object>): PrintStream
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, obj: Object): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, s: String): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, b: boolean): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, c: char): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, s: array<char>): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, d: double): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, f: float): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, i: int): void
    {
        action TODO();
    }


    fun *.print (@target self: PrintStream, l: long): void
    {
        action TODO();
    }


    @varargs fun *.printf (@target self: PrintStream, l: Locale, format: String, args: array<Object>): PrintStream
    {
        action TODO();
    }


    @varargs fun *.printf (@target self: PrintStream, format: String, args: array<Object>): PrintStream
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: Object): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: String): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: boolean): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: char): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: array<char>): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: double): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: float): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: int): void
    {
        action TODO();
    }


    fun *.println (@target self: PrintStream, x: long): void
    {
        action TODO();
    }


    @throws(["java.io.IOException"])
    // within java.io.OutputStream
    fun *.write (@target self: PrintStream, b: array<byte>): void
    {
        action TODO();
    }


    fun *.write (@target self: PrintStream, buf: array<byte>, off: int, len: int): void
    {
        action TODO();
    }


    fun *.write (@target self: PrintStream, b: int): void
    {
        action TODO();
    }

}
