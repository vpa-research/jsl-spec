libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/CharSequence.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type CharSequence
    is java.lang.CharSequence
    for Object
{
    fun length(): int;

    fun charAt(index: int): char;
}


// global aliases and type overrides

