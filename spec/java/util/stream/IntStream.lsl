//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/IntStream.java";

// imports

import java/util/stream/Stream;
import java/util/PrimitiveIterator;
import java/util/Spliterator;


// primary semantic types

@interface type IntStream
    is java.util.stream.IntStream
    for Stream
{
}


// global aliases and type overrides

@GenerateMe
@implements("java.util.stream.IntStream")
@public type IntStreamLSL
    is java.util.stream.IntStreamLSL
    for IntStream
{
}


@GenerateMe
@implements("java.util.PrimitiveIterator.OfInt")
@public type IntStreamLSLIterator
    is java.util.stream.IntStreamLSLIterator
    for PrimitiveIterator_OfInt
{
}
