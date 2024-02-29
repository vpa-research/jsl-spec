libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/regex/Pattern.java";

// imports

import java/io/Serializable;


// primary semantic types

type Pattern
    is java.util.regex.Pattern
    for Serializable
{
}


// global aliases and type overrides

