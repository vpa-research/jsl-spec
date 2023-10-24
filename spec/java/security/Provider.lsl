libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Provider.java";

// imports

import java/lang/Object;


// local semantic types

@extends("java.util.Properties")
@abstract type Provider
    is java.security.Provider
    for Object
{
    @private @static @final var serialVersionUID: long = -4298000515446427739L;
}