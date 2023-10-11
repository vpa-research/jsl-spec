//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Spliterator.java";

// imports

import java/lang/Object;
import java/util/function/Consumer;
import java/util/function/DoubleConsumer;
import java/util/function/IntConsumer;
import java/util/function/LongConsumer;


// primary semantic types

@Parameterized(["T"])
@interface type Spliterator
    is java.util.Spliterator
    for Object
{
    fun *.characteristics(): int;

    fun *.forEachRemaining(@Parameterized(["? super T"]) _action: Consumer): void;

    fun *.getExactSizeIfKnown(): long;

    fun *.tryAdvance(@Parameterized(["? super T"]) _action: Consumer): boolean;

    @ParameterizedResult(["T"])
    fun *.trySplit(): Object; //Spliterator; // #problem: self-reference
}

val SPLITERATOR_DISTINCT:   int = 1;
val SPLITERATOR_SORTED:     int = 4;
val SPLITERATOR_ORDERED:    int = 16;
val SPLITERATOR_SIZED:      int = 64;
val SPLITERATOR_NONNULL:    int = 256;
val SPLITERATOR_IMMUTABLE:  int = 1024;
val SPLITERATOR_CONCURRENT: int = 4096;
val SPLITERATOR_SUBSIZED:   int = 16384;


@interface type Spliterator_OfPrimitive
    is java.util.Spliterator.OfPrimitive
    for Spliterator
{
    fun *.forEachRemaining(_action: Object): void;

    fun *.tryAdvance(_action: Object): boolean;

    fun *.trySplit(): Spliterator; //Spliterator_OfPrimitive; // #problem: self-reference
}


@interface type Spliterator_OfDouble
    is java.util.Spliterator.OfDouble
    for Spliterator_OfPrimitive
{
    fun *.forEachRemaining(_action: DoubleConsumer): void;

    fun *.tryAdvance(_action: DoubleConsumer): boolean;
}


@interface type Spliterator_OfInt
    is java.util.Spliterator.OfInt
    for Spliterator_OfPrimitive
{
    fun *.forEachRemaining(_action: IntConsumer): void;

    fun *.tryAdvance(_action: IntConsumer): boolean;
}


@interface type Spliterator_OfLong
    is java.util.Spliterator.OfLong
    for Spliterator_OfPrimitive
{
    fun *.forEachRemaining(_action: LongConsumer): void;

    fun *.tryAdvance(_action: LongConsumer): boolean;
}


// global aliases and type overrides

