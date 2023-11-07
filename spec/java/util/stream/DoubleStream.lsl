//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/DoubleStream.java";

// imports

import java/util/stream/Stream;
import java/util/PrimitiveIterator;
import java/util/Spliterator;


// primary semantic types

@interface type DoubleStream
    is java.util.stream.DoubleStream
    for Stream
{
}


// global aliases and type overrides

@GenerateMe
@implements("java.util.stream.DoubleStream")
@public type DoubleStreamLSL
    is java.util.stream.DoubleStreamLSL
    for DoubleStream
{
}


@GenerateMe
@implements("java.util.PrimitiveIterator.OfDouble")
@public type DoubleStreamLSLIterator
    is java.util.stream.DoubleStreamLSLIterator
    for PrimitiveIterator_OfDouble
{
}


@GenerateMe
@implements("java.util.Spliterator.OfDouble")
@public type DoubleStreamLSLSpliterator
    is java.util.DoubleStreamLSLSpliterator
    for Spliterator_OfDouble
{
}