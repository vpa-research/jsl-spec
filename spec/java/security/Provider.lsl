//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Provider.java";

// imports

import java/util/Properties;
import java/lang/String;
import java/util/Set;
import java/lang/Object;


// primary semantic types

@extends("java.util.Properties")
@abstract type Provider
    is java.security.Provider
    for Properties
{
    @private @static val serialVersionUID: long = -4298000515446427739L;

    fun *.getName(): String;

    fun *.getServices(): Set;
}


@static type Provider_Service
    is java.security.Provider.Service
    for Object
{
    fun *.getType(): String;

    fun *.getAlgorithm(): String;
}


// global aliases and type overrides