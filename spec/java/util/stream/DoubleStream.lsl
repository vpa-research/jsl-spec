//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/DoubleStream.java";

// imports

import java/util/stream/Stream;
import java/lang/Double;
import java/util/function/DoubleFunction;
import java/util/function/DoublePredicate;
import java/util/function/DoubleUnaryOperator;
import java/util/function/DoubleToLongFunction;
import java/util/function/DoubleToIntFunction;
import java/util/function/DoubleBinaryOperator;
import java/util/function/ObjDoubleConsumer;
import java/util/DoubleSummaryStatistics;
import java/util/PrimitiveIterator;


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
    @private @static val STREAM_VALUE: Object = 1;
}


@GenerateMe
@implements("java.util.Iterator")
@public type DoubleStreamLSLIterator
    is java.util.stream.DoubleStreamLSLIterator
    for Iterator
{
}