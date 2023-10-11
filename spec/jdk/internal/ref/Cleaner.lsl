//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/jdk/internal/ref/Cleaner.java";

// imports

import java/lang/PhantomReference;


// primary semantic types

type Cleaner
    is jdk.internal.ref.Cleaner
    for PhantomReference
{
    fun *.clean(): void;
}


// global aliases and type overrides

