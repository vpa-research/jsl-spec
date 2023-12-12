//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Provider.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/util/Properties;
import java/util/Set;


// primary semantic types

@abstract type Provider
    is java.security.Provider
    for Properties
{
    fun *.getName(): String;

    fun *.getServices(): Set;
}


type Provider_Service
    is java.security.Provider.Service
    for Object
{
    fun *.getType(): String;

    fun *.getAlgorithm(): String;
}


// global aliases and type overrides

