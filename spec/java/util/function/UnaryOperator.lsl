//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/UnaryOperator.java";

// imports

import java/lang/Object;
import java/util/function/Function;


// primary semantic types

@Parameterized(["T"])
@interface type UnaryOperator
    is java.util.function.UnaryOperator
    for Function
{
    // fun apply(t: Object): Object;
}
