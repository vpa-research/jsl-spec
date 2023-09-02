//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/util/stream";

// imports

import java.common;
import java/lang/_interfaces;


// semantic types

type BaseStream
    is java.util.stream.BaseStream
    for Object
{
    @ParameterizedResult(["T"])
    fun iterator(): Iterator;

    @ParameterizedResult(["T"])
    fun spliterator(): Spliterator;

    fun isParallel(): boolean;

    fun close(): void;
}



@Parameterized(["T"])
type Stream
    is java.util.stream.Stream
    for BaseStream
{
    fun forEach(@Parameterized(["? super T"]) _action: Consumer): void;

    fun forEachOrdered(@Parameterized(["? super T"]) _action: Consumer): void;

    fun toArray(): array<Object>;
}


type DoubleStream
    is java.util.stream.DoubleStream
    for Stream
{
}


type IntStream
    is java.util.stream.IntStream
    for Stream
{
}


type LongStream
    is java.util.stream.LongStream
    for Stream
{
}
