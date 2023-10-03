//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java/lang/_interfaces;
import java/io/_interfaces;


// primary types

@implements("java.io.Serializable")
@implements("java.lang.Comparable<StringBuffer>")
@implements("java.lang.CharSequence")
@public @final type StringBuffer
    is java.lang.StringBuffer
    for Object
{
    @private @static val serialVersionUID: long = 3388685877147921107L;
}