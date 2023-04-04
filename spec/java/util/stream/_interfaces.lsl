libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";


@TypeMapping("java.util.stream.DoubleStream")
typealias DoubleStream = Object;    // #problem

@TypeMapping("java.util.stream.IntStream")
typealias IntStream = Object;    // #problem

@TypeMapping("java.util.stream.LongStream")
typealias LongStream = Object;    // #problem

@TypeMapping("java.util.stream.Stream")
typealias Stream = Object;    // #problem
