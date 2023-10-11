//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/IntStream.java";

// imports

import java/util/stream/Stream;
import java/lang/Integer;
import java/util/function/IntPredicate;
import java/util/function/IntUnaryOperator;
import java/util/function/IntToLongFunction;
import java/util/function/IntToDoubleFunction;
import java/util/function/IntBinaryOperator;
import java/util/function/ObjIntConsumer;
import java/util/IntSummaryStatistics;
import java/util/PrimitiveIterator;


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
    @private @static val STREAM_VALUE: Object = 1;
}


@GenerateMe
@implements("java.util.Iterator")
@public type IntStreamLSLIterator
    is java.util.stream.IntStreamLSLIterator
    for Iterator
{
}