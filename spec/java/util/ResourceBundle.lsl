//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ResourceBundle.java";

// imports

import java/lang/Object;


// primary semantic types

@abstract type ResourceBundle
    is java.util.ResourceBundle
    for Object
{
}


// global aliases and type overrides

