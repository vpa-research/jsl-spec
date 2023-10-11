//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Number.java";

// imports

import java/io/Serializable;


// primary semantic types

@interface type Number
    is java.lang.Number
    for Serializable
{
    fun *.byteValue(): byte;

    fun *.doubleValue(): double;

    fun *.floatValue(): float;

    fun *.intValue(): int;

    fun *.longValue(): long;

    fun *.shortValue(): short;
}


// global aliases and type overrides

