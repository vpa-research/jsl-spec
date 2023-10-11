//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/BaseStream.java";

// imports

import java/lang/AutoCloseable;
import java/util/Iterator;
import java/util/Spliterator;


// primary semantic types

@Parameterized(["T", "S"])
@interface type BaseStream
    is java.util.stream.BaseStream
    for AutoCloseable
{
    @ParameterizedResult(["T"])
    fun iterator(): Iterator;

    @ParameterizedResult(["T"])
    fun spliterator(): Spliterator;

    fun isParallel(): boolean;

    fun close(): void;
}


// global aliases and type overrides

