libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Enumeration.java";

// imports

import java/lang/Object;
import java/util/Iterator;


// primary semantic types

@Parameterized(["E"])
@interface type Enumeration
    is java.util.Enumeration
    for Object
{
    fun *.hasMoreElements(): boolean;

    fun *.nextElement(): Object;

    @ParameterizedResult(["E"])
    fun *.asIterator(): Iterator;
}


// global aliases and type overrides

