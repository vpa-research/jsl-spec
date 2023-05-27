//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

import java-common;


type DoubleStream is java.util.stream.DoubleStream for Object {
    // ???
}

@TypeMapping("java.util.stream.IntStream")
typealias IntStream = Object;    // #problem

@TypeMapping("java.util.stream.LongStream")
typealias LongStream = Object;    // #problem

@TypeMapping("java.util.stream.Stream")
typealias Stream = Object;    // #problem
