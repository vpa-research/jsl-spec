libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/Consumer.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type Consumer
    is java.util.function.Consumer
    for Object
{
    fun accept(t: Object): void;
}
