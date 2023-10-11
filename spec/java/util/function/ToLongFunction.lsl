//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ToLongFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type ToLongFunction
    is java.util.function.ToLongFunction
    for Object
{
    fun applyAsLong(value: Object): long;
}
