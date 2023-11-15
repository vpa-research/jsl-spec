//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Float.java";

// imports

import java/lang/Comparable;
import java/lang/Class;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("floatValue")
@final type Float
    is java.lang.Float
    for Comparable, Number
{
    // WARNING: use 'floatValue' to get primitive value
}


// global aliases and type overrides

// note: this is a partial implementation, no need for additional constraints (abstract class) and synthetic methods (Comparable)
// @extends("java.lang.Number")
// @implements("java.lang.Comparable<Float>")
@final type LSLFloat
    is java.lang.Float
    for Float
{
    @private @static val serialVersionUID: long = -2671257302660747028L;

    @public @static val BYTES: int = 4;
    @public @static val SIZE: int = 32;

    @public @static val MAX_EXPONENT: int = 127;
    @public @static val MIN_EXPONENT: int = -126;

    // #problem: no "scientific" notation support
    @public @static val MAX_VALUE: float = action DEBUG_DO("3.4028235e+38f");
    @public @static val MIN_VALUE: float = action DEBUG_DO("1.4e-45f");

    @public @static val MIN_NORMAL: float = action DEBUG_DO("1.17549435e-38f");

    @public @static val NEGATIVE_INFINITY: float = -1.0f / 0.0f;
    @public @static val POSITIVE_INFINITY: float = 1.0f / 0.0f;
    @public @static val NaN: float = 0.0f / 0.0f;

    // #problem: unable to get reference to primitive type
    @public @static val TYPE: Class = action TYPE_OF("Float"); // preventing recursion
}
