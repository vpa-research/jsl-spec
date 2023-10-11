//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/DoubleFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["R"])
@interface type DoubleFunction
    is java.util.function.DoubleFunction
    for Object
{
    fun apply(value: double): Object;
}
