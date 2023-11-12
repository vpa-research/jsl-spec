//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Double.java";

// imports

import java/lang/Comparable;
import java/lang/Number;
import java/lang/Object;
import java/lang/String;


// local semantic types

@extends("java.lang.Number")
@implements("java.lang.Comparable")
@public @final type Double
    is java.lang.Double
    for Object
{
    @private @static @final var serialVersionUID: long = -9172774392245257468;

    @static @final @public var BYTES: int = 8;
    @static @final @public var MAX_EXPONENT: int = 1023;
    @static @final @public var MAX_VALUE: double = 1.7976931348623157E308;
    @static @final @public var MIN_EXPONENT: int = -1022;
    @static @final @public var MIN_NORMAL: double = 2.2250738585072014E-308;
    @static @final @public var MIN_VALUE: double = 4.9E-324;
    @static @final @public var NEGATIVE_INFINITY: double = -Infinity;
    @static @final @public var NaN: double = NaN;
    @static @final @public var POSITIVE_INFINITY: double = Infinity;
    @static @final @public var SIZE: int = 64;
    @static @final @public var TYPE: Class = double;
}


// automata

automaton DoubleAutomaton
(
)
: Double
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        Double (Double, String),
        Double (Double, double),
        // static operations
        compare,
        doubleToLongBits,
        doubleToRawLongBits,
        hashCode (double),
        isFinite,
        isInfinite (double),
        isNaN (double),
        longBitsToDouble,
        max,
        min,
        parseDouble,
        sum,
        toHexString,
        toString (double),
        valueOf (String),
        valueOf (double),
    ];

    shift Initialized -> self by [
        // instance methods
        byteValue,
        compareTo,
        doubleValue,
        equals,
        floatValue,
        hashCode (Double),
        intValue,
        isInfinite (Double),
        isNaN (Double),
        longValue,
        shortValue,
        toString (Double),
    ];

    // internal variables

    // utilities

    // constructors

    @throws(["java.lang.NumberFormatException"])
    constructor *.Double (@target self: Double, s: String)
    {
        action TODO();
    }


    constructor *.Double (@target self: Double, value: double)
    {
        action TODO();
    }


    // static methods

    @static fun *.compare (d1: double, d2: double): int
    {
        action TODO();
    }


    @static fun *.doubleToLongBits (value: double): long
    {
        action TODO();
    }


    @static fun *.doubleToRawLongBits (arg0: double): long
    {
        action TODO();
    }


    @static fun *.hashCode (value: double): int
    {
        action TODO();
    }


    @static fun *.isFinite (d: double): boolean
    {
        action TODO();
    }


    @static fun *.isInfinite (v: double): boolean
    {
        action TODO();
    }


    @static fun *.isNaN (v: double): boolean
    {
        action TODO();
    }


    @static fun *.longBitsToDouble (arg0: long): double
    {
        action TODO();
    }


    @static fun *.max (a: double, b: double): double
    {
        action TODO();
    }


    @static fun *.min (a: double, b: double): double
    {
        action TODO();
    }


    @throws(["java.lang.NumberFormatException"])
    @static fun *.parseDouble (s: String): double
    {
        action TODO();
    }


    @static fun *.sum (a: double, b: double): double
    {
        action TODO();
    }


    @static fun *.toHexString (d: double): String
    {
        action TODO();
    }


    @static fun *.toString (d: double): String
    {
        action TODO();
    }


    @throws(["java.lang.NumberFormatException"])
    @static fun *.valueOf (s: String): Double
    {
        action TODO();
    }


    @static fun *.valueOf (d: double): Double
    {
        action TODO();
    }


    // methods

    fun *.byteValue (@target self: Double): byte
    {
        action TODO();
    }


    fun *.compareTo (@target self: Double, anotherDouble: Double): int
    {
        action TODO();
    }


    fun *.doubleValue (@target self: Double): double
    {
        action TODO();
    }


    fun *.equals (@target self: Double, obj: Object): boolean
    {
        action TODO();
    }


    fun *.floatValue (@target self: Double): float
    {
        action TODO();
    }


    fun *.hashCode (@target self: Double): int
    {
        action TODO();
    }


    fun *.intValue (@target self: Double): int
    {
        action TODO();
    }


    fun *.isInfinite (@target self: Double): boolean
    {
        action TODO();
    }


    fun *.isNaN (@target self: Double): boolean
    {
        action TODO();
    }


    fun *.longValue (@target self: Double): long
    {
        action TODO();
    }


    fun *.shortValue (@target self: Double): short
    {
        action TODO();
    }


    fun *.toString (@target self: Double): String
    {
        action TODO();
    }

}
