//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ToLongBiFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T", "U"])
@interface type ToLongBiFunction
    is java.util.function.ToLongBiFunction
    for Object
{
    fun applyAsLong(t: Object, u: Object): long;
}
