libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Throwable.java";

// imports

import java/io/Serializable;
import java/lang/String;


// primary semantic types

type Throwable
    is java.lang.Throwable
    for Serializable
{
}


// global aliases and type overrides

@implements("java.io.Serializable")
@public type LSLThrowable
    is java.lang.Throwable
    for Throwable
{
    @private @static val serialVersionUID: long = -3042686055658047285L;

    @private @static val NULL_CAUSE_MESSAGE       : String = "Cannot suppress a null exception.";
    @private @static val SELF_SUPPRESSION_MESSAGE : String = "Self-suppression not permitted";
    @private @static val CAUSE_CAPTION            : String = "Caused by: ";
    @private @static val SUPPRESSED_CAPTION       : String = "Suppressed: ";
}
