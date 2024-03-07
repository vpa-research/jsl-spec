libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/regex/Matcher.java";

// imports

import java/util/regex/MatchResult;


// primary semantic types

type Matcher
    is java.util.regex.Matcher
    for MatchResult
{
}


// global aliases and type overrides

