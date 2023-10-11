//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/PrimitiveIterator.java";

// imports

import java/lang/Double;
import java/lang/Integer;
import java/lang/Long;
import java/lang/Object;
import java/util/Iterator;
import java/util/function/Consumer;
import java/util/function/DoubleConsumer;
import java/util/function/IntConsumer;
import java/util/function/LongConsumer;


// primary semantic types

@Parameterized(["T", "T_CONS"])
@interface type PrimitiveIterator
    is java.util.PrimitiveIterator
    for Iterator
{
    fun *.forEachRemaining(_action: Object): void;
}


@interface type PrimitiveIterator_OfDouble
    is java.util.PrimitiveIterator.OfDouble
    for PrimitiveIterator
{
    fun *.next(): Double;

    fun *.nextDouble(): double;

    fun *.forEachRemaining(_action: DoubleConsumer): void;
}


@interface type PrimitiveIterator_OfInt
    is java.util.PrimitiveIterator.OfInt
    for PrimitiveIterator
{
    fun *.next(): Integer;

    fun *.nextInt(): int;

    fun *.forEachRemaining(_action: IntConsumer): void;
}


@interface type PrimitiveIterator_OfLong
    is java.util.PrimitiveIterator.OfLong
    for PrimitiveIterator
{
    fun *.next(): Long;

    fun *.nextLong(): long;

    fun *.forEachRemaining(_action: LongConsumer): void;
}


// global aliases and type overrides

