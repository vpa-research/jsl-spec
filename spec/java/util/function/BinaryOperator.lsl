libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/BinaryOperator.java";

// imports

import java/lang/Object;
import java/util/function/BiFunction;


// primary semantic types

@Parameterized(["T"])
@interface type BinaryOperator
    is java.util.function.BinaryOperator
    for BiFunction
{
    // fun apply(ta: Object, tb: Object): Object;
}
