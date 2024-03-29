libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/ObjLongConsumer.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type ObjLongConsumer
    is java.util.function.ObjLongConsumer
    for Object
{
    fun accept(t: Object, value: long): void;
}
