libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Collector.java";

// imports

import java/lang/Object;
import java/util/function/BiConsumer;
import java/util/function/BinaryOperator;
import java/util/function/Function;
import java/util/function/Supplier;
import java/util/Spliterator;


// primary semantic types

@Parameterized(["T", "A", "R"])
@interface type Collector
    is java.util.stream.Collector
    for Object
{
    @ParameterizedResult(["A"])
    fun supplier(): Supplier;

    @ParameterizedResult(["A", "T"])
    fun accumulator(): BiConsumer;

    @ParameterizedResult(["A"])
    fun combiner(): BinaryOperator;

    @ParameterizedResult(["A", "R"])
    fun finisher(): Function;
}


// global aliases and type overrides

