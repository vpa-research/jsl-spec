//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/LongFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["R"])
@interface type LongFunction
    is java.util.function.LongFunction
    for Object
{
    fun apply(value: long): Object;
}
