//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/Supplier.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type Supplier
    is java.util.function.Supplier
    for Object
{
    fun get(): Object;
}
