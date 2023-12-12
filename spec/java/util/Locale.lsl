//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Locale.java";

// imports

import java/io/Serializable;
import java/lang/Cloneable;


// primary semantic types

@final type Locale
    is java.util.Locale
    for Cloneable, Serializable
{
}


// global aliases and type overrides
