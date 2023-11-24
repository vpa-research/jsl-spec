//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/SecurityManager.java";

// imports

import java/lang/Object;
import java/security/Permission;


// primary semantic types

@public type SecurityManager
    is java.lang.SecurityManager
    for Object
{
    fun *.checkPermission(perm: Permission): void;
}


// global aliases and type overrides

@public type LSLSecurityManager
    is java.lang.SecurityManager
    for SecurityManager
{
}
