//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Double.java";

// imports

import java/lang/Comparable;
import java/lang/Class;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("doubleValue")
@final type Double
    is java.lang.Double
    for Comparable, Number
{
    // WARNING: use 'doubleValue' to get primitive value

    @static fun *.isNaN(x: double): boolean;

    @static fun *.isFinite(x: double): boolean;
    @static fun *.isInfinite(x: double): boolean;

    @static fun *.valueOf(x: double): Number; // #problem: self-reference
}


// global aliases and type overrides

// note: this is a partial implementation, no need for additional constraints (abstract class) and synthetic methods (Comparable)
// @extends("java.lang.Number")
// @implements("java.lang.Comparable<Float>")
@final type LSLDouble
    is java.lang.Double
    for Double
{
    @private @static val serialVersionUID: long = -9172774392245257468L;

    @static val BYTES: int = 8;
    @static val SIZE: int = 64;

    @static val MAX_EXPONENT: int = 1023;
    @static val MIN_EXPONENT: int = -1022;

    // #problem: no support for scientific notation
    @static val MAX_VALUE: double = action DEBUG_DO("1.7976931348623157E308");
    @static val MIN_VALUE: double = action DEBUG_DO("4.9E-324");
    @static val MIN_NORMAL: double = action DEBUG_DO("2.2250738585072014E-308");

    @static val POSITIVE_INFINITY: double = 1.0 / 0.0;
    @static val NEGATIVE_INFINITY: double = -1.0 / 0.0;

    @static val NaN: double = 0.0 / 0.0;

    @static val TYPE: Class = action TYPE_OF("Double");
}
