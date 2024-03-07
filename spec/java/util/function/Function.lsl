libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/Function.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T", "R"])
@interface type Function
    is java.util.function.Function
    for Object
{
    fun apply(t: Object): Object;
}
