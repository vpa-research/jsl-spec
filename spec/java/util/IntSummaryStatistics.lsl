libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/IntSummaryStatistics.java";

// imports

import java/lang/Object;
import java/util/function/IntConsumer;


// primary semantic types

@FunctionalInterface("accept")
type IntSummaryStatistics
    is java.util.IntSummaryStatistics
    for IntConsumer
{
    fun *.accept(value: int): void;

    // #problem: self-reference
    fun *.combine(other: any /* IntSummaryStatistics */): void;

    fun *.getAverage(): double;

    fun *.getCount(): long;

    fun *.getMin(): int;

    fun *.getMax(): int;

    fun *.getSum(): long;
}


// global aliases and type overrides

