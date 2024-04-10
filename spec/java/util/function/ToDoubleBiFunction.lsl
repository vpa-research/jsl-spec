libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ToDoubleBiFunction.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T", "U"])
@interface type ToDoubleBiFunction
    is java.util.function.ToDoubleBiFunction
    for Object
{
    fun applyAsDouble(t: Object, u: Object): double;
}
