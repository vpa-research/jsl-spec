libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/IntConsumer.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type IntConsumer
    is java.util.function.IntConsumer
    for Object
{
    fun accept(value: int): void;
}
