//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/charset/Charset.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/CharBuffer;
import java/util/Locale;
import java/util/Set;
import java/util/SortedMap;

import java/nio/charset/Charset;


// automata

automaton CharsetAutomaton
(
)
: LSLCharset
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,

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
        compareTo,
        decode,
        displayName (LSLCharset),
        displayName (LSLCharset, Locale),
        encode (LSLCharset, CharBuffer),
        encode (LSLCharset, String),
        equals,
        hashCode,
        isRegistered,
        name,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @protected constructor *.`<init>` (@target self: LSLCharset, canonicalName: String, aliases: array<String>)
    {
        action TODO();
    }


    // static methods

    @static fun *.availableCharsets (): SortedMap
    {
        action TODO();
    }


    @static fun *.defaultCharset (): LSLCharset
    {
        action TODO();
    }


    @static fun *.forName (charsetName: String): LSLCharset
    {
        action TODO();
    }


    @static fun *.isSupported (charsetName: String): boolean
    {
        action TODO();
    }


    // methods

    @final fun *.aliases (@target self: LSLCharset): Set
    {
        action TODO();
    }


    fun *.canEncode (@target self: LSLCharset): boolean
    {
        // just like the original
        result = true;
    }


    @final fun *.compareTo (@target self: LSLCharset, that: Charset): int
    {
        action TODO();
    }


    @final fun *.decode (@target self: LSLCharset, bb: ByteBuffer): CharBuffer
    {
        action TODO();
    }


    fun *.displayName (@target self: LSLCharset): String
    {
        action TODO();
    }


    fun *.displayName (@target self: LSLCharset, locale: Locale): String
    {
        action TODO();
    }


    @final fun *.encode (@target self: LSLCharset, cb: CharBuffer): ByteBuffer
    {
        action TODO();
    }


    @final fun *.encode (@target self: LSLCharset, str: String): ByteBuffer
    {
        action TODO();
    }


    @final fun *.equals (@target self: LSLCharset, ob: Object): boolean
    {
        action TODO();
    }


    @final fun *.hashCode (@target self: LSLCharset): int
    {
        action TODO();
    }


    @final fun *.isRegistered (@target self: LSLCharset): boolean
    {
        action TODO();
    }


    @final fun *.name (@target self: LSLCharset): String
    {
        action TODO();
    }


    @final fun *.toString (@target self: LSLCharset): String
    {
        action TODO();
    }

}
