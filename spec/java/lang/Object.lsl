libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Object.java";

// imports

import java.common;


// primary semantic types

type Object
    is java.lang.Object
    for Object
{
    // WARNING: use OBJECT_HASH_CODE and OBJECT_EQUALS actions instead of calling these methods directly

    // #problem: breaks automatic "functional-interface" inference
    //fun *.getClass(): any; // #problem: cyclic dependency
}

val SOMETHING: Object = action DEBUG_DO("new java.lang.Object()");


// global aliases and type overrides

@public type LSLObject
    is java.lang.Object
    for Object
{
}
