///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Random.java";

// imports

import java/io/Serializable;
import java/io/ObjectStreamField;


// primary semantic types

@implements("java.io.Serializable")
@public type Random
    is java.util.Random
    for Serializable
{
    // #problem: no serialization support
    @private @static val serialVersionUID: long = 3905348978240129619L;
    @private @static val serialPersistentFields: array<ObjectStreamField> = [];
}

val RANDOM_STREAM_SIZE_MAX: int = 100;
