//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk8/blob/master/jdk/src/share/classes/sun/misc/Version.java.template";

// imports

import java/lang/Object;


// primary semantic types

@interface type SUN_Version
    is sun.misc.Version
    for Object
{
    @static fun *.init(): void;
}


// global aliases and type overrides

