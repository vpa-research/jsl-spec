//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Spliterators.java";

// imports

import java/lang/Object;
import java/util/Iterator;
import java/util/PrimitiveIterator;
import java/util/Spliterator;


// primary semantic types

@final type Spliterators
    is java.util.Spliterators
    for Object
{
    // #todo: add automata implementations

    @static fun *.emptySpliterator(): Spliterator;

    @static fun *.emptyDoubleSpliterator(): Spliterator_OfDouble;

    @static fun *.emptyIntSpliterator(): Spliterator_OfInt;

    @static fun *.emptyLongSpliterator(): Spliterator_OfLong;

    @static fun *.iterator(spliterator: Spliterator): Iterator;

    @static fun *.iterator(spliterator: Spliterator_OfDouble): PrimitiveIterator_OfDouble;

    @static fun *.iterator(spliterator: Spliterator_OfInt): PrimitiveIterator_OfInt;

    @static fun *.iterator(spliterator: Spliterator_OfLong): PrimitiveIterator_OfLong;
}


// global aliases and type overrides

@GenerateMe
@implements("java.util.Spliterator")
@final type Spliterators_ArraySpliterator
    is java.util.Spliterators_ArraySpliterator // #problem: private class
    for Spliterator
{
}


@GenerateMe
@implements("java.util.Spliterator.OfDouble")
@final type Spliterators_DoubleArraySpliterator
    is java.util.Spliterators_DoubleArraySpliterator // #problem: private class
    for Spliterator_OfDouble
{
}


@GenerateMe
@implements("java.util.Spliterator.OfInt")
@final type Spliterators_IntArraySpliterator
    is java.util.Spliterators_IntArraySpliterator // #problem: private class
    for Spliterator_OfInt
{
}


@GenerateMe
@implements("java.util.Spliterator.OfLong")
@final type Spliterators_LongArraySpliterator
    is java.util.Spliterators_LongArraySpliterator // #problem: private class
    for Spliterator_OfLong
{
}

