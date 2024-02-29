libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/LongBinaryOperator.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type LongBinaryOperator
    is java.util.function.LongBinaryOperator
    for Object
{
    fun applyAsLong(left: long, right: long): long;
}
