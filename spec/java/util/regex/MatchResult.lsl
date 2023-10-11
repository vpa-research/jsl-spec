//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/regex/MatchResult.java";

// imports

import java/lang/Object;
import java/lang/String;


// primary semantic types

@interface type MatchResult
    is java.util.regex.MatchResult
    for Object
{
    fun *.end(): int;

    fun *.end(group: int): int;

    fun *.group(): String;

    fun *.group(group: int): String;

    fun *.groupCount(): int;

    fun *.start(): int;

    fun *.start(group: int): int;
}


// global aliases and type overrides

