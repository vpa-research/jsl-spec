//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/util/stream";

// imports

import java.common;


// semantic types

@Parameterized(["T"])
type Stream
    is java.util.stream.Stream
    for Object
{
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
