libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/SecureRandom.java";

// imports

import java/util/Random;


// primary semantic types

@extends("java.util.Random")
@public type SecureRandom
    is java.security.SecureRandom
    for Random
{
    @private @static val serialVersionUID: long = 4940670005562187L;
    @private @static val defaultProvidersMap: map<String, Object> = action MAP_NEW();
}