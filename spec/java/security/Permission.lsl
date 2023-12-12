//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/Permission.java";

// imports

import java/io/Serializable;
import java/lang/String;
import java/security/Guard;


// primary semantic types

type Permission
    is java.security.Permission
    for Guard, Serializable
{
    fun *.getName(): String;

    fun *.getActions(): String;

    // #problem: cyclic reference
    //fun newPermissionCollection(): PermissionCollection;
}


// global aliases and type overrides

