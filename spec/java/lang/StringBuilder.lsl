libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java/io/Serializable;
import java/lang/CharSequence;
import java/lang/Comparable;


// primary semantic types

@implements("java.io.Serializable")
@implements("java.lang.Comparable<StringBuilder>")
@implements("java.lang.CharSequence")
@final type StringBuilder
    is java.lang.StringBuilder
    for Serializable, Comparable, CharSequence
{
    @private @static val serialVersionUID: long = 4383685877147921099L;
}


// global aliases and type overrides

@implements("java.io.Serializable")
@implements("java.lang.Comparable<StringBuilder>")
@implements("java.lang.CharSequence")
@public @final type LSLStringBuilder
    is java.lang.StringBuilder
    for StringBuilder
{
    @private @static val serialVersionUID: long = 4383685877147921099L;

    @private @static val STRINGBUILDER_LENGTH_MAX: int = 50;
}
