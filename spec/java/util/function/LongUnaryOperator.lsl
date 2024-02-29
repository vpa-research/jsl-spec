libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/LongUnaryOperator.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type LongUnaryOperator
    is java.util.function.LongUnaryOperator
    for Object
{
    fun applyAsLong(operand: long): long;
}
