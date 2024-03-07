libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/IntUnaryOperator.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type IntUnaryOperator
    is java.util.function.IntUnaryOperator
    for Object
{
    fun applyAsInt(operand: int): int;
}
