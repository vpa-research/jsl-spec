//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/LongSupplier.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type LongSupplier
    is java.util.function.LongSupplier
    for Object
{
    fun getAsLong(): long;
}
