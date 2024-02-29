//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/PrintStream.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;
import java/util/Locale;

import java/lang/System;
import libsl/utils/VoidOutputStream;


// automata

automaton System_PrintStreamAutomaton
(
)
: System_PrintStream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        append (System_PrintStream, CharSequence),
        append (System_PrintStream, CharSequence, int, int),
        append (System_PrintStream, char),
        checkError,
        close,
        flush,
        format (System_PrintStream, Locale, String, array<Object>),
        format (System_PrintStream, String, array<Object>),
        print (System_PrintStream, Object),
        print (System_PrintStream, String),
        print (System_PrintStream, boolean),
        print (System_PrintStream, char),
        print (System_PrintStream, array<char>),
        print (System_PrintStream, double),
        print (System_PrintStream, float),
        print (System_PrintStream, int),
        print (System_PrintStream, long),
        printf (System_PrintStream, Locale, String, array<Object>),
        printf (System_PrintStream, String, array<Object>),
        println (System_PrintStream),
        println (System_PrintStream, Object),
        println (System_PrintStream, String),
        println (System_PrintStream, boolean),
        println (System_PrintStream, char),
        println (System_PrintStream, array<char>),
        println (System_PrintStream, double),
        println (System_PrintStream, float),
        println (System_PrintStream, int),
        println (System_PrintStream, long),
        write (System_PrintStream, array<byte>),
        write (System_PrintStream, array<byte>, int, int),
        write (System_PrintStream, int),
    ];

    // internal variables

    var closed: boolean = false;
    var error: boolean = false;


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _checkOpen (): void
    {
        if (this.closed)
            this.error = true;
    }


    // constructors

    // static methods

    // methods

    fun *.append (@target self: System_PrintStream, csq: CharSequence): PrintStream
    {
        _checkOpen();

        result = self as Object as PrintStream;
    }


    fun *.append (@target self: System_PrintStream, csq: CharSequence, start: int, end: int): PrintStream
    {
        if (csq == null)
            csq = "null";

        val size: int = action CALL_METHOD(csq, "length", []);
        if (start < 0 || end >= size)
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        _checkOpen();

        result = self as Object as PrintStream;
    }


    fun *.append (@target self: System_PrintStream, c: char): PrintStream
    {
        _checkOpen();

        result = self as Object as PrintStream;
    }


    fun *.checkError (@target self: System_PrintStream): boolean
    {
        result = this.error;
    }


    fun *.close (@target self: System_PrintStream): void
    {
        // #todo: add synchronization for parallel executions
        this.closed = true;
    }


    fun *.flush (@target self: System_PrintStream): void
    {
        // #todo: add synchronization for parallel executions
        _checkOpen();
    }


    @varargs fun *.format (@target self: System_PrintStream, l: Locale, format: String, args: array<Object>): PrintStream
    {
        if (format == null)
            _throwNPE();

        _checkOpen();

        result = self as Object as PrintStream;
    }


    @varargs fun *.format (@target self: System_PrintStream, format: String, args: array<Object>): PrintStream
    {
        if (format == null)
            _throwNPE();

        _checkOpen();

        result = self as Object as PrintStream;
    }


    fun *.print (@target self: System_PrintStream, obj: Object): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, s: String): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, b: boolean): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, c: char): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, s: array<char>): void
    {
        if (s == null)
            _throwNPE();

        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, d: double): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, f: float): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, i: int): void
    {
        _checkOpen();
    }


    fun *.print (@target self: System_PrintStream, l: long): void
    {
        _checkOpen();
    }


    @varargs fun *.printf (@target self: System_PrintStream, l: Locale, format: String, args: array<Object>): PrintStream
    {
        if (l == null || format == null || args == null)
            _throwNPE();

        _checkOpen();

        result = self as Object as PrintStream;
    }


    @varargs fun *.printf (@target self: System_PrintStream, format: String, args: array<Object>): PrintStream
    {
        if (format == null || args == null)
            _throwNPE();

        _checkOpen();

        result = self as Object as PrintStream;
    }


    fun *.println (@target self: System_PrintStream): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: Object): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: String): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: boolean): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: char): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: array<char>): void
    {
        if (x == null)
            _throwNPE();

        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: double): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: float): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: int): void
    {
        _checkOpen();
    }


    fun *.println (@target self: System_PrintStream, x: long): void
    {
        _checkOpen();
    }


    @throws(["java.io.IOException"])
    // within java.io.OutputStream
    fun *.write (@target self: System_PrintStream, b: array<byte>): void
    {
        if (b == null)
            _throwNPE();

        _checkOpen();
    }


    fun *.write (@target self: System_PrintStream, buf: array<byte>, off: int, len: int): void
    {
        if (buf == null)
            _throwNPE();

        val size: int = action ARRAY_SIZE(buf);
        if (off < 0 || off + len > size)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        _checkOpen();
    }


    fun *.write (@target self: System_PrintStream, b: int): void
    {
        _checkOpen();
    }


    // special methods

    @Phantom @static fun *.`<super>` (): array<Object>
    {
        result = [
            null as OutputStream,
        ];
    }

}
