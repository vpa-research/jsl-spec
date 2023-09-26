//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/AccessControlContext.java";

// imports

import java.common;


// primary semantic types

@public type AccessControlContext
    is java.security.AccessControlContext
    for Object
{
}
