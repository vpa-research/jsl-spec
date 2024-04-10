libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/BooleanSupplier.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type BooleanSupplier
    is java.util.function.BooleanSupplier
    for Object
{
    fun getAsBoolean(): boolean;
}
