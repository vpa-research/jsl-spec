libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Appendable.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type Appendable
    is java.lang.Appendable
    for Object
{
    // #problem: self-reference in return types
}


// global aliases and type overrides

