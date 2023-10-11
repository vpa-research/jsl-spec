//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/DoubleSummaryStatistics.java";

// imports

import java/lang/Object;
import java/util/function/DoubleConsumer;


// primary semantic types

@FunctionalInterface("accept")
type DoubleSummaryStatistics
    is java.util.DoubleSummaryStatistics
    for DoubleConsumer
{
    fun *.accept(value: double): void;

    // #problem: self-reference
    fun *.combine(other: any /* DoubleSummaryStatistics */): void;

    fun *.getAverage(): double;

    fun *.getCount(): long;

    fun *.getMin(): double;

    fun *.getMax(): double;

    fun *.getSum(): double;
}


// global aliases and type overrides

