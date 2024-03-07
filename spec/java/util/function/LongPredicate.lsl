libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/function/LongPredicate.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type LongPredicate
    is java.util.function.LongPredicate
    for Object
{
    fun test(value: long): boolean;
}
