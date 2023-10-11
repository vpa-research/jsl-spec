//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/net/InetAddress.java";

// imports

import java/lang/Object;


// primary semantic types

@public type InetAddress
    is java.net.InetAddress
    for Object
{
}
