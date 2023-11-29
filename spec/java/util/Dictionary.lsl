//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Dictionary.java";

// imports

import java/lang/Object;
import java/util/Enumeration;


// primary semantic types

@abstract type Dictionary
    is java.util.Dictionary
    for Object
{
    fun *.size(): int;

    fun *.isEmpty(): boolean;

    fun *.keys(): Enumeration;

    fun *.elements(): Enumeration;

    fun *.get(key: Object): Object;

    fun *.put(key: Object, value: Object): Object;

    fun *.remove(key: Object): Object;
}


// global aliases and type overrides