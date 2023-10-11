//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ListIterator.java";

// imports

import java/lang/Object;
import java/util/Iterator;


// primary semantic types

@Parameterized(["E"])
@interface type ListIterator
    is java.util.ListIterator
    for Iterator
{
    fun add(e: Object): void;

    fun hasPrevious(): boolean;

    fun nextIndex(): int;

    fun previous(): Object;

    fun previousIndex(): int;

    fun set(e: Object): void;
}


// global aliases and type overrides

