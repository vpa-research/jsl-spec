libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/SecureRandomParameters.java";

// imports

import java/lang/Object;


// local semantic types

@interface type SecureRandomParameters
    is java.security.SecureRandomParameters
    for Object
{
}