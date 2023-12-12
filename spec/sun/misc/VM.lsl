//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk8/blob/master/jdk/src/share/classes/sun/misc/VM.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type SUN_VM
    is sun.misc.VM
    for Object
{
    @static fun *.booted(): void;
}


// global aliases and type overrides

