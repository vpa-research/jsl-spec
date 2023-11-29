//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Security.java";

// imports

import java/lang/Object;
import java/security/Provider;


// primary semantic types

@final type Security
    is java.security.Security
    for Object
{
    @static *.getProviders(): array<Provider>;

    @static *.getProperty(key: String): String;
}


// global aliases and type overrides