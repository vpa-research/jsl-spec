libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Spliterators.java";

// imports

import java/lang/Object;
import java/util/Collection;
import java/util/Iterator;
import java/util/PrimitiveIterator;
import java/util/Spliterator;

import java/util/Spliterators;


// automata

automaton SpliteratorsAutomaton
(
)
: Spliterators
{
    // states and shifts

    initstate Allocated;

    shift Allocated -> self by [
        // constructors
        `<init>`,

        // static operations
        emptyDoubleSpliterator,
        emptyIntSpliterator,
        emptyLongSpliterator,
        emptySpliterator,
        iterator (Spliterator_OfDouble),
        iterator (Spliterator_OfInt),
        iterator (Spliterator_OfLong),
        iterator (Spliterator),
        spliterator (Collection, int),
        spliterator (Iterator, long, int),
        spliterator (array<Object>, int),
        spliterator (array<Object>, int, int, int),
        spliterator (PrimitiveIterator_OfDouble, long, int),
        spliterator (PrimitiveIterator_OfInt, long, int),
        spliterator (PrimitiveIterator_OfLong, long, int),
        spliterator (array<double>, int),
        spliterator (array<double>, int, int, int),
        spliterator (array<int>, int),
        spliterator (array<int>, int, int, int),
        spliterator (array<long>, int),
        spliterator (array<long>, int, int, int),
        spliteratorUnknownSize (Iterator, int),
        spliteratorUnknownSize (PrimitiveIterator_OfDouble, int),
        spliteratorUnknownSize (PrimitiveIterator_OfInt, int),
        spliteratorUnknownSize (PrimitiveIterator_OfLong, int),
    ];

    // internal variables

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: Spliterators)
    {
        // nothing - this is a utility class
    }


    // static methods

    @Phantom @static fun *.emptyDoubleSpliterator (): Spliterator_OfDouble
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.emptyIntSpliterator (): Spliterator_OfInt
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.emptyLongSpliterator (): Spliterator_OfLong
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.emptySpliterator (): Spliterator
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.iterator (spliterator: Spliterator_OfDouble): PrimitiveIterator_OfDouble
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.iterator (spliterator: Spliterator_OfInt): PrimitiveIterator_OfInt
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.iterator (spliterator: Spliterator_OfLong): PrimitiveIterator_OfLong
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.iterator (spliterator: Spliterator): Iterator
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliterator (c: Collection, characteristics: int): Spliterator
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliterator (iterator: Iterator, size: long, characteristics: int): Spliterator
    {
        // #todo: using the original method for now
        action TODO();
    }


    @static fun *.spliterator (arr: array<Object>, additionalCharacteristics: int): Spliterator
    {
        result = new Spliterators_ArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = 0,
            fence = action ARRAY_SIZE(arr),
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @static fun *.spliterator (arr: array<Object>, fromIndex: int, toIndex: int, additionalCharacteristics: int): Spliterator
    {
        result = new Spliterators_ArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = fromIndex,
            fence = toIndex,
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @Phantom @static fun *.spliterator (iterator: PrimitiveIterator_OfDouble, size: long, characteristics: int): Spliterator_OfDouble
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliterator (iterator: PrimitiveIterator_OfInt, size: long, characteristics: int): Spliterator_OfInt
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliterator (iterator: PrimitiveIterator_OfLong, size: long, characteristics: int): Spliterator_OfLong
    {
        // #todo: using the original method for now
        action TODO();
    }


    @static fun *.spliterator (arr: array<double>, additionalCharacteristics: int): Spliterator_OfDouble
    {
        result = new Spliterators_DoubleArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = 0,
            fence = action ARRAY_SIZE(arr),
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @static fun *.spliterator (arr: array<double>, fromIndex: int, toIndex: int, additionalCharacteristics: int): Spliterator_OfDouble
    {
        result = new Spliterators_DoubleArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = fromIndex,
            fence = toIndex,
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @static fun *.spliterator (arr: array<int>, additionalCharacteristics: int): Spliterator_OfInt
    {
        result = new Spliterators_IntArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = 0,
            fence = action ARRAY_SIZE(arr),
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @static fun *.spliterator (arr: array<int>, fromIndex: int, toIndex: int, additionalCharacteristics: int): Spliterator_OfInt
    {
        result = new Spliterators_IntArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = fromIndex,
            fence = toIndex,
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @static fun *.spliterator (arr: array<long>, additionalCharacteristics: int): Spliterator_OfLong
    {
        result = new Spliterators_LongArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = 0,
            fence = action ARRAY_SIZE(arr),
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @static fun *.spliterator (arr: array<long>, fromIndex: int, toIndex: int, additionalCharacteristics: int): Spliterator_OfLong
    {
        result = new Spliterators_LongArraySpliteratorAutomaton(state = Initialized,
            array = arr,
            index = fromIndex,
            fence = toIndex,
            characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );
    }


    @Phantom @static fun *.spliteratorUnknownSize (iterator: Iterator, characteristics: int): Spliterator
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliteratorUnknownSize (iterator: PrimitiveIterator_OfDouble, characteristics: int): Spliterator_OfDouble
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliteratorUnknownSize (iterator: PrimitiveIterator_OfInt, characteristics: int): Spliterator_OfInt
    {
        // #todo: using the original method for now
        action TODO();
    }


    @Phantom @static fun *.spliteratorUnknownSize (iterator: PrimitiveIterator_OfLong, characteristics: int): Spliterator_OfLong
    {
        // #todo: using the original method for now
        action TODO();
    }


    // methods
}
