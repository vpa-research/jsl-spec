//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ToIntFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type ToIntFunction
    is java.util.function.ToIntFunction
    for Object
{
    fun applyAsInt(t: Object): int;
}
