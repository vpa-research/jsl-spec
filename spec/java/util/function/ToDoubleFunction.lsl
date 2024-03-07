libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ToDoubleFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type ToDoubleFunction
    is java.util.function.ToDoubleFunction
    for Object
{
    fun applyAsDouble(t: Object): double;
}
