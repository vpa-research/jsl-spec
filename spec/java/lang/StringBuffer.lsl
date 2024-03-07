libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuffer.java";

// imports

import java/io/Serializable;
import java/lang/Appendable;
import java/lang/CharSequence;
import java/lang/Comparable;


// primary semantic types

@implements("java.io.Serializable")
@implements("java.lang.Comparable<StringBuffer>")
@implements("java.lang.CharSequence")
@final type StringBuffer
    is java.lang.StringBuffer
    for Serializable, Appendable, Comparable, CharSequence
{
    @private @static val serialVersionUID: long = 3388685877147921107L;
}


// global aliases and type overrides

@implements("java.io.Serializable")
@implements("java.lang.Comparable<StringBuffer>")
@implements("java.lang.CharSequence")
@public @final type LSLStringBuffer
    is java.lang.StringBuffer
    for StringBuffer
{
    @private @static val serialVersionUID: long = 3388685877147921107L;

    @private @static val STRINGBUFFER_LENGTH_MAX: int = 50;
}