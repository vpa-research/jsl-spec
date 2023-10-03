libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java.common;
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
    //@private @static @final var serialVersionUID: long = 3388685877147921107;
    @static val MAX_CODE_POINT: int = 1114111;
    @static val MIN_CODE_POINT: int = 0;
    @static val MIN_LOW_SURROGATE: int = 56320;
    @static val MIN_HIGH_SURROGATE: int = 55296;
    @static val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;
}