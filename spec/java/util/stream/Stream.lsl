//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Stream.java";

// imports

import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// new/introduced types

@GenerateMe
@implements("java.util.stream.Stream")
@public type StreamLSL
    is java.util.stream.StreamLSL
    for Stream
{
    @static val STREAM_VALUE: Object = 1;
}


@GenerateMe
@implements("java.util.Iterator")
@public type StreamLSLIterator
    is java.util.stream.StreamLSLIterator
    for Iterator
{
}