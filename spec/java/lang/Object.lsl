libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Object.java";

// imports

import java/lang/_interfaces;


// public semantic types

@public type LSLObject
    is java.lang.Object
    for Object
{
}
