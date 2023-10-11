//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/IntStream.java";

// imports

import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// new/introduced types

@GenerateMe
@implements("java.util.stream.IntStream")
@public type IntStreamLSL
    is java.util.stream.IntStreamLSL
    for IntStream
{
    @private @static val STREAM_VALUE: Object = 1;
}


@GenerateMe
@implements("java.util.Iterator")
@public type IntStreamLSLIterator
    is java.util.stream.IntStreamLSLIterator
    for Iterator
{
}