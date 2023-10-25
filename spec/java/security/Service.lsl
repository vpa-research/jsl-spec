libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Provider.java";

// imports

import java/lang/Object;


// local semantic types

@GenerateMe
@public @static type Service
    is java.security.Service
    for Object
{
}