//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Class.java";

// imports

import java/io/Serializable;
import java/lang/String;


// primary semantic types

@final type Class
    is java.lang.Class
    // #problem: no reflection support
    for Serializable //, GenericDeclaration, Type, AnnotatedElement
{
    fun *.getCanonicalName(): String;

    fun *.getName(): String;

    fun *.getPackageName(): String;
}


// global aliases and type overrides

