//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/IntStream.java";

// imports

import java/util/stream/Stream;


// primary semantic types

@interface type IntStream
    is java.util.stream.IntStream
    for Stream
{
}


// global aliases and type overrides

