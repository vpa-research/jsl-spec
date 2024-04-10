libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Guard.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type Guard
    is java.security.Guard
    for Object
{
    @throws(["java.lang.SecurityException"])
    fun *.checkGuard(obj: Object): void;
}


// global aliases and type overrides

