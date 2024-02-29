libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Iterable.java";

// imports

import java/lang/Object;
import java/util/function/Consumer;
import java/util/Iterator;
import java/util/Spliterator;


// primary semantic types

@Parameterized(["T"])
@interface type Iterable
    is java.lang.Iterable
    for Object
{
    fun *.forEach(@Parameterized(["? super T"]) _action: Consumer): void;

    fun *.iterator(): Iterator;

    // #problem: cannot use Spliterator and Consumer here
    fun *.spliterator(): Spliterator;
}


// global aliases and type overrides

