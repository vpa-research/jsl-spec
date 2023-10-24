libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/SecureRandomSpi.java";

// imports

import java/io/Serializable;
import java/lang/Object;


// local semantic types

@implements("java.io.Serializable")
@abstract type SecureRandomSpi
    is java.security.SecureRandomSpi
    for Object, Serializable
{
    @private @static @final var serialVersionUID: long = -2991854161009191830L;
}