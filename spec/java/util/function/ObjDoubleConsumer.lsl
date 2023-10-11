//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ObjDoubleConsumer.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type ObjDoubleConsumer
    is java.util.function.ObjDoubleConsumer
    for Object
{
    fun accept(t: Object, value: double): void;
}
