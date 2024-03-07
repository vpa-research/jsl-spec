libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/jdk/internal/util/StaticProperty.java";

// imports

import java/lang/Object;
import java/lang/String;


// primary semantic types

type StaticProperty
    is jdk.internal.util.StaticProperty
    for Object
{
    @static fun *.javaHome(): String;

    @static fun *.jdkSerialFilter(): String;

    @static fun *.userDir(): String;

    @static fun *.userHome(): String;

    @static fun *.userName(): String;
}


// global aliases and type overrides

