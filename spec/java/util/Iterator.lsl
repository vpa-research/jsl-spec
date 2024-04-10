libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Iterator.java";

// imports

import java/lang/Object;
import java/util/function/Consumer;


// primary semantic types

@Parameterized(["E"])
@interface type Iterator
    is java.util.Iterator
    for Object
{
    fun *.forEachRemaining(@Parameterized(["? super E"]) _action: Consumer): void;

    fun *.hasNext(): boolean;

    fun *.next(): Object;

    fun *.remove(): void;
}


// global aliases and type overrides

