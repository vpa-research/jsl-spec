//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LongSummaryStatistics.java";

// imports

import java/lang/Object;
import java/util/function/LongConsumer;


// primary semantic types

@FunctionalInterface("accept")
type LongSummaryStatistics
    is java.util.LongSummaryStatistics
    for LongConsumer
{
    fun *.accept(value: long): void;

    // #problem: self-reference
    fun *.combine(other: any /* LongSummaryStatistics */): void;

    fun *.getAverage(): double;

    fun *.getCount(): long;

    fun *.getMin(): long;

    fun *.getMax(): long;

    fun *.getSum(): long;
}


// global aliases and type overrides

