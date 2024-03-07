libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ToIntBiFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T", "U"])
@interface type ToIntBiFunction
    is java.util.function.ToIntBiFunction
    for Object
{
    fun applyAsInt(t: Object, u: Object): int;
}
