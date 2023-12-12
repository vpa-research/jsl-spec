//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/SecureRandomSpi.java";

// imports

import java/io/Serializable;


// primary semantic types

@abstract type SecureRandomSpi
    is java.security.SecureRandomSpi
    for Serializable
{
}


// global aliases and type overrides

