libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/BiConsumer.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T", "U"])
@interface type BiConsumer
    is java.util.function.BiConsumer
    for Object
{
    fun accept(t: Object, u: Object): void;

    // #question: do we need combinational methods?
}
