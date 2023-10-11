//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/IntFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["R"])
@interface type IntFunction
    is java.util.function.IntFunction
    for Object
{
    fun apply(value: int): Object;
}
