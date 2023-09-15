//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;


// === CONSTANTS ===


// primary types

@implements("java.io.Serializable")
@implements("java.lang.Comparable<StringBuilder>")
@implements("java.lang.CharSequence")
@public @final type StringBuilder
    is java.lang.StringBuilder
    for Object
{
    //@private @static @final var serialVersionUID: long = 4383685877147921099;
    @static val MAX_CODE_POINT: int = 1114111;
    @static val MIN_CODE_POINT: int = 0;
    @static val MIN_LOW_SURROGATE: int = 56320;
    @static val MIN_HIGH_SURROGATE: int = 55296;
    @static val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;
}
