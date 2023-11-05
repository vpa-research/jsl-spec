//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/charset/Charset.java";

// imports

import java/lang/Comparable;
import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/CharBuffer;
import java/util/Locale;
import java/util/Set;
import java/util/SortedMap;


// local semantic types

@implements("java.lang.Comparable")
@public @abstract type Charset
    is java.nio.charset.Charset
    for Object
{
}


// automata

automaton CharsetAutomaton
(
)
: Charset
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        Charset,
        // static operations
        availableCharsets,
        defaultCharset,
        forName,
        isSupported,
    ];

    shift Initialized -> self by [
        // instance methods
        aliases,
        canEncode,
        compareTo (Charset, Charset),
        compareTo (Charset, Object),
        decode,
        displayName (Charset),
        displayName (Charset, Locale),
        encode (Charset, CharBuffer),
        encode (Charset, String),
        equals,
        hashCode,
        isRegistered,
        name,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @protected constructor *.Charset (@target self: Charset, canonicalName: String, aliases: array<String>)
    {
        action TODO();
    }


    // static methods

    @static fun *.availableCharsets (): SortedMap
    {
        action TODO();
    }


    @static fun *.defaultCharset (): Charset
    {
        action TODO();
    }


    @static fun *.forName (charsetName: String): Charset
    {
        action TODO();
    }


    @static fun *.isSupported (charsetName: String): boolean
    {
        action TODO();
    }


    // methods

    @final fun *.aliases (@target self: Charset): Set
    {
        action TODO();
    }


    fun *.canEncode (@target self: Charset): boolean
    {
        action TODO();
    }


    @final fun *.compareTo (@target self: Charset, that: Charset): int
    {
        action TODO();
    }


    // within java.lang.Comparable
    fun *.compareTo (@target self: Charset, arg0: Object): int
    {
        action TODO();
    }


    @final fun *.decode (@target self: Charset, bb: ByteBuffer): CharBuffer
    {
        action TODO();
    }


    fun *.displayName (@target self: Charset): String
    {
        action TODO();
    }


    fun *.displayName (@target self: Charset, locale: Locale): String
    {
        action TODO();
    }


    @final fun *.encode (@target self: Charset, cb: CharBuffer): ByteBuffer
    {
        action TODO();
    }


    @final fun *.encode (@target self: Charset, str: String): ByteBuffer
    {
        action TODO();
    }


    @final fun *.equals (@target self: Charset, ob: Object): boolean
    {
        action TODO();
    }


    @final fun *.hashCode (@target self: Charset): int
    {
        action TODO();
    }


    @final fun *.isRegistered (@target self: Charset): boolean
    {
        action TODO();
    }


    @final fun *.name (@target self: Charset): String
    {
        action TODO();
    }


    @final fun *.toString (@target self: Charset): String
    {
        action TODO();
    }

}
