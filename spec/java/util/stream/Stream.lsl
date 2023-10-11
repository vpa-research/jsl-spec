//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Stream.java";

// imports

import java/lang/Object;
import java/util/Iterator;
import java/util/function/Consumer;
import java/util/stream/BaseStream;


// primary semantic types

@Parameterized(["T"])
@interface type Stream
    is java.util.stream.Stream
    for BaseStream
{
    fun forEach(@Parameterized(["? super T"]) _action: Consumer): void;

    fun forEachOrdered(@Parameterized(["? super T"]) _action: Consumer): void;

    fun toArray(): array<Object>;
}


// global aliases and type overrides

@GenerateMe
@implements("java.util.stream.Stream")
@public type StreamLSL
    is java.util.stream.StreamLSL
    for Stream
{
}


@GenerateMe
@implements("java.util.Iterator")
@public type StreamLSLIterator
    is java.util.stream.StreamLSLIterator
    for Iterator
{
}