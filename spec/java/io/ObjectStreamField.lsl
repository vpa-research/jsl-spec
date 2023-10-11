//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/ObjectStreamField.java";

// imports

import java/lang/Comparable;


// primary semantic types

type ObjectStreamField
    is java.io.ObjectStreamField
    for Comparable
{
}
