libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java/util/ArrayList;


// automata

// TODO: use common array-based Stream automaton (see org.utbot.engine.overrides.stream.UtStream)

automaton ArrayList_StreamAutomaton
(
)
: ArrayList_Stream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        allMatch,
        anyMatch,
        close,
        collect (ArrayList_Stream, Collector),
        collect (ArrayList_Stream, Supplier, BiConsumer, BiConsumer),
        count,
        distinct,
        dropWhile,
        equals,
        filter,
        findAny,
        findFirst,
        flatMap,
        flatMapToDouble,
        flatMapToInt,
        flatMapToLong,
        forEach,
        forEachOrdered,
        hashCode,
        isParallel,
        iterator,
        limit,
        map,
        mapToDouble,
        mapToInt,
        mapToLong,
        max,
        min,
        noneMatch,
        onClose,
        parallel,
        peek,
        reduce (ArrayList_Stream, BinaryOperator),
        reduce (ArrayList_Stream, Object, BiFunction, BinaryOperator),
        reduce (ArrayList_Stream, Object, BinaryOperator),
        sequential,
        skip,
        sorted (ArrayList_Stream),
        sorted (ArrayList_Stream, Comparator),
        spliterator,
        takeWhile,
        toArray (ArrayList_Stream),
        toArray (ArrayList_Stream, IntFunction),
        toString,
        unordered,
    ];

    // internal variables

    // utilities

    // constructors

    // static methods

    // methods

    // within java.util.stream.ReferencePipeline
    fun *.allMatch (@target self: ArrayList_Stream, predicate: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.anyMatch (@target self: ArrayList_Stream, predicate: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.close (@target self: ArrayList_Stream): void
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.collect (@target self: ArrayList_Stream, collector: Collector): Object
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.collect (@target self: ArrayList_Stream, supplier: Supplier, accumulator: BiConsumer, combiner: BiConsumer): Object
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.count (@target self: ArrayList_Stream): long
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.distinct (@target self: ArrayList_Stream): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.dropWhile (@target self: ArrayList_Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.equals (@target self: ArrayList_Stream, obj: Object): boolean
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.filter (@target self: ArrayList_Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.findAny (@target self: ArrayList_Stream): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.findFirst (@target self: ArrayList_Stream): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMap (@target self: ArrayList_Stream, mapper: Function): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMapToDouble (@target self: ArrayList_Stream, mapper: Function): DoubleStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMapToInt (@target self: ArrayList_Stream, mapper: Function): IntStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMapToLong (@target self: ArrayList_Stream, mapper: Function): LongStream
    {
        action TODO();
    }


    fun *.forEach (@target self: ArrayList_Stream, _action: Consumer): void
    {
        action TODO();
    }


    fun *.forEachOrdered (@target self: ArrayList_Stream, _action: Consumer): void
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.hashCode (@target self: ArrayList_Stream): int
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.isParallel (@target self: ArrayList_Stream): boolean
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.iterator (@target self: ArrayList_Stream): Iterator
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.limit (@target self: ArrayList_Stream, maxSize: long): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.map (@target self: ArrayList_Stream, mapper: Function): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.mapToDouble (@target self: ArrayList_Stream, mapper: ToDoubleFunction): DoubleStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.mapToInt (@target self: ArrayList_Stream, mapper: ToIntFunction): IntStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.mapToLong (@target self: ArrayList_Stream, mapper: ToLongFunction): LongStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.max (@target self: ArrayList_Stream, comparator: Comparator): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.min (@target self: ArrayList_Stream, comparator: Comparator): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.noneMatch (@target self: ArrayList_Stream, predicate: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.onClose (@target self: ArrayList_Stream, closeHandler: Runnable): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.parallel (@target self: ArrayList_Stream): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.peek (@target self: ArrayList_Stream, _action: Consumer): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.reduce (@target self: ArrayList_Stream, accumulator: BinaryOperator): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.reduce (@target self: ArrayList_Stream, identity: Object, accumulator: BiFunction, combiner: BinaryOperator): Object
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.reduce (@target self: ArrayList_Stream, identity: Object, accumulator: BinaryOperator): Object
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.sequential (@target self: ArrayList_Stream): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.skip (@target self: ArrayList_Stream, n: long): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.sorted (@target self: ArrayList_Stream): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.sorted (@target self: ArrayList_Stream, comparator: Comparator): Stream
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.spliterator (@target self: ArrayList_Stream): Spliterator
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.takeWhile (@target self: ArrayList_Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.toArray (@target self: ArrayList_Stream): array<Object>
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.toArray (@target self: ArrayList_Stream, generator: IntFunction): array<Object>
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.toString (@target self: ArrayList_Stream): String
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.unordered (@target self: ArrayList_Stream): Stream
    {
        action TODO();
    }

}
