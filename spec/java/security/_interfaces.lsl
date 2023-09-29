//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/io";

// imports

import java/lang/_interfaces;


// semantic types

type Permission
    is java.security.Permission
    for Object
{
    fun getName(): String;

    fun getActions(): String;

    // #problem: cyclic reference
    //fun newPermissionCollection(): PermissionCollection;
}
