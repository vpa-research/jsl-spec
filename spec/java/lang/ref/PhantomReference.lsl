//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/ref/PhantomReference.java";

// imports

import java/lang/ref/Reference;


// primary semantic types

@Parameterized(["T"])
type PhantomReference
    is java.lang.ref.PhantomReference
    for Reference
{
}


// global aliases and type overrides

