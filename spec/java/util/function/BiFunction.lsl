libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/BiFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T", "U", "R"])
@interface type BiFunction
    is java.util.function.BiFunction
    for Object
{
    fun apply(t: Object, u: Object): Object;
}
