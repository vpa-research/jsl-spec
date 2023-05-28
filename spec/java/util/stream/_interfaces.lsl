//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

import java.common;


type DoubleStream is java.util.stream.DoubleStream for Object {
    // ???
}

type IntStream is java.util.stream.IntStream for Object {
    // ???
}

type LongStream is java.util.stream.LongStream for Object {
    // ???
}

@TypeMapping("java.util.stream.Stream")
typealias Stream = Object;    // #problem
