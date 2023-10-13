//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/LongStream.java";

// imports

import java/util/stream/Stream;


// primary semantic types

@interface type LongStream
    is java.util.stream.LongStream
    for Stream
{
}


// global aliases and type overrides

@GenerateMe
@implements("java.util.stream.LongStream")
@public type LongStreamLSL
    is java.util.stream.LongStreamLSL
    for LongStream
{
    @private @static val STREAM_VALUE: Object = 1;
}


@GenerateMe
@implements("java.util.PrimitiveIterator.OfLong")
@public type LongStreamLSLIterator
    is java.util.stream.LongStreamLSLIterator
    for PrimitiveIterator_OfLong
{
}