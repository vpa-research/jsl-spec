//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Stream.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;
import java/util/Optional;


// primary types

@GenerateMe
@implements("java.util.stream.Stream")
@public type StreamLSL
    is java.util.stream.StreamLSL
    for Stream
{
}