libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Stream.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;
import java/util/Optional;


// automata

automaton StreamAutomaton
(
    var storage: array<Object>,
    @transient  var length: int
)
: Stream
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // static operations
        /*builder,
        concat,
        empty,
        generate,
        iterate (Object, Predicate, UnaryOperator),
        iterate (Object, UnaryOperator),
        of (Object),
        of (array<Object>),
        ofNullable,*/
    ];

    shift Initialized -> self by [
        // instance methods
        filter,
        map,
        mapToInt,
        mapToLong,
        mapToDouble,
        flatMap,
        flatMapToInt,
        flatMapToLong,
        flatMapToDouble,
        sorted (Stream),
        sorted (Stream, Comparator),
        peek,
        limit,
        skip,
        forEach,
        forEachOrdered,
        toArray (Stream),
        toArray (Stream, IntFunction),
        reduce (Stream, Object, BinaryOperator),
        reduce (Stream, BinaryOperator),
        reduce (Stream, Object, BiFunction, BinaryOperator),
        collect (Stream, Supplier, BiConsumer, BiConsumer),
        collect (Stream, Collector),
        min,
        max,
        count,
        anyMatch,
        allMatch,
        noneMatch,
        findFirst,
        findAny,
        /*close,
        dropWhile,
        isParallel,
        iterator,
        onClose,
        parallel,
        sequential,
        spliterator,
        takeWhile,
        unordered,*/
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _flatMap (mapper: Function): Stream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<Object> = action DEBUG_DO("Arrays.stream(this.storage).flatMap(mapper).collect(Collectors.toList()).toArray()");
        val mappedLength: int = action ARRAY_SIZE(mappedStorage);

        result = new StreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = mappedLength,
        );
    }


    proc _actionApply (_action: Consumer): Stream
    {
        if (_action == null)
            _throwNPE();

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _actionApply_loop(i, _action)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
        );
    }


    @Phantom proc _actionApply_loop (i: int, _action: Consumer): void
    {
        this.storage[i] = action CALL(_action, [this.storage[i]]);
    }


    proc _findFirst (): Optional
    {
        if (this.length == 0)
        {
            result = action DEBUG_DO("Optional.empty()");
        }
        else
        {
            val first: Object = this.storage[0];
            result = action DEBUG_DO("Optional.of(first)");
        }
    }

    // constructors

    // static methods

    /*
    @static fun *.builder (): Builder
    {
        action TODO();
    }


    @static fun *.concat (a: Stream, b: Stream): Stream
    {
        action TODO();
    }


    @static fun *.empty (): Stream
    {
        action TODO();
    }


    @static fun *.generate (s: Supplier): Stream
    {
        action TODO();
    }


    @static fun *.iterate (seed: Object, hasNext: Predicate, next: UnaryOperator): Stream
    {
        action TODO();
    }


    @static fun *.iterate (seed: Object, f: UnaryOperator): Stream
    {
        action TODO();
    }


    @static fun *.of (t: Object): Stream
    {
        action TODO();
    }


    @static @varargs fun *.of (values: array<Object>): Stream
    {
        action TODO();
    }


    @static fun *.ofNullable (t: Object): Stream
    {
        action TODO();
    }
    */


    // methods

    fun *.filter (@target self: Stream, predicate: Predicate): Stream
    {
        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = filteredStorage,
            length = filteredLength,
        );
    }


    @Phantom proc _filter_loop (i: int, predicate: Predicate, filteredLength: int, filteredStorage: array<Object>): void
    {
        if (action CALL(predicate, [this.storage[i]]))
        {
            filteredStorage[filteredLength] = this.storage[i];
            filteredLength += 1;
        }
    }


    fun *.map (@target self: Stream, mapper: Function): Stream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapped_loop(i, mapper, mappedStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
        );
    }


    @Phantom proc _mapped_loop (i: int, mapper: Function, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToInt (@target self: Stream, mapper: ToIntFunction): IntStream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToInt_loop(i, mapper, mappedStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
        );
    }


    @Phantom proc _mapToInt_loop (i: int, mapper: ToIntFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToLong (@target self: Stream, mapper: ToLongFunction): LongStream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToLong_loop(i, mapper, mappedStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
        );
    }


    @Phantom proc _mapToLong_loop (i: int, mapper: ToLongFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: Stream, mapper: ToDoubleFunction): DoubleStream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToDouble_loop(i, mapper, mappedStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
        );
    }


    @Phantom proc _mapToDouble_loop (i: int, mapper: ToDoubleFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: Stream, mapper: Function): Stream
    {
        result = _flatMap(mapper);
    }


    fun *.flatMapToInt (@target self: Stream, mapper: Function): IntStream
    {
        result = _flatMap(mapper);
    }


    fun *.flatMapToLong (@target self: Stream, mapper: Function): LongStream
    {
        result = _flatMap(mapper);
    }


    fun *.flatMapToDouble (@target self: Stream, mapper: Function): DoubleStream
    {
        result = _flatMap(mapper);
    }


    fun *.distinct (@target self: Stream): Stream
    {
        action ASSUME(this.length == 3);

        val first: int = this.storage[0];
        val second: int = this.storage[1];
        val third: int = this.storage[2];

        val distinctStorage: array<int> = action ARRAY_NEW("java.lang.Object", 3);
        var distinctLength: int = 0;

        if (first != second && first != third)
        {
            distinctStorage[distinctLength] = first;
            distinctLength += 1;
        }

        if (second != first && second != third)
        {
            distinctStorage[distinctLength] = second;
            distinctLength += 1;
        }

        if (third != second && third != first)
        {
            distinctStorage[distinctLength] = third;
            distinctLength += 1;
        }

        result = new StreamAutomaton(state = Initialized,
            storage = distinctStorage,
            length = distinctLength,
        );
    }


    fun *.sorted (@target self: Stream): Stream
    {
        if (this.length == 0)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
            );
        }
        else
        {
            // plain bubble sorting algorithm
            val outerLimit: int = this.length - 1;
            var innerLimit: int = 0;
            var i: int = 0;
            var j: int = 0;
            action LOOP_FOR(
                i, 0, outerLimit, +1,
                sort_loop_outer(i, j, innerLimit)
            );

            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
            );
        }
    }


    @Phantom proc sort_loop_outer (i: int, j: int, innerLimit: int): void
    {
        innerLimit = this.length - i - 1;
        action LOOP_FOR(
            j, 0, innerLimit, +1,
            sort_loop_inner(j)
        );
    }


    @Phantom proc sort_loop_inner (j: int): void
    {
        val idxA: int = j;
        val idxB: int = j + 1;
        val a: Object = this.storage[idxA];
        val b: Object = this.storage[idxB];

        // "compareTo" - that's right ??
        if (action DEBUG_DO("a.compareTo(b)") > 0)
        {
            this.storage[idxA] = b;
            this.storage[idxB] = a;
        }
    }


    fun *.sorted (@target self: Stream, comparator: Comparator): Stream
    {
        if (this.length == 0)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
            );
        }
        else
        {
            // plain bubble sorting algorithm
            val outerLimit: int = this.length - 1;
            var innerLimit: int = 0;
            var i: int = 0;
            var j: int = 0;
            action LOOP_FOR(
                i, 0, outerLimit, +1,
                sort_loop_outer_with_comparator(i, j, innerLimit, comparator)
            );

            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
            );
        }
    }


    @Phantom proc sort_loop_outer_with_comparator (i: int, j: int, innerLimit: int, comparator: Comparator): void
    {
        innerLimit = this.length - i - 1;
        action LOOP_FOR(
            j, 0, innerLimit, +1,
            sort_loop_inner_with_comparator(j, comparator)
        );
    }


    @Phantom proc sort_loop_inner_with_comparator (j: int, comparator: Comparator): void
    {
        val idxA: int = j;
        val idxB: int = j + 1;
        val a: Object = this.storage[idxA];
        val b: Object = this.storage[idxB];

        // "compareTo" - that's right ??
        if (action CALL(comparator, [a, b]) > 0)
        {
            this.storage[idxA] = b;
            this.storage[idxB] = a;
        }
    }


    fun *.peek (@target self: Stream, _action: Consumer): Stream
    {
        result = _actionApply(_action);
    }


    // maxSize: long - what to do with this ? Array
    fun *.limit (@target self: Stream, maxSize: long): Stream
    {
        if (maxSize < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSize == 0)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
            );
        }
        // Maybe only change length field ? And don't change storage ?
        else
        {
            // what will be if will be overflow ?
            val maxSizeInt: int = maxSize as int;
            val limitStorage: array<Object> = action ARRAY_NEW("java.lang.Object", maxSizeInt);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, maxSizeInt, +1,
                _limit_loop(i, limitStorage)
            );

            result = new StreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
            );
        }
    }


    @Phantom proc _limit_loop (i: int, limitStorage: array<Object>): void
    {
        limitStorage[i] = this.storage[i];
    }


    fun *.skip (@target self: Stream, n: long): Stream
    {
        if (n < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (n == 0)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
            );
        }
        else
        {
            // what will be if will be overflow ?
            val offset: int = n as int;
            val newLength: int = this.length - offset;
            val skipStorage: array<Object> = action ARRAY_NEW("java.lang.Object", newLength);

            var i: int = 0;
            var skipIndex: int = 0;
            action LOOP_FOR(
                i, offset, this.length, +1,
                _skip_loop(i, skipIndex, skipStorage)
            );

            result = new StreamAutomaton(state = Initialized,
                storage = skipStorage,
                length = newLength,
            );
        }
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<Object>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }


    fun *.forEach (@target self: Stream, _action: Consumer): void
    {
        _actionApply(_action);
    }


    fun *.forEachOrdered (@target self: Stream, _action: Consumer): void
    {
        _actionApply(_action);
    }


    fun *.toArray (@target self: Stream): array<Object>
    {
        result = this.storage;
    }


    fun *.toArray (@target self: Stream, generator: IntFunction): array<Object>
    {
        val generatedArray: array<Object> = action CALL(generator,[this.length]);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _copyToArray_loop(i, generatedArray)
        );
        result = generatedArray;
    }


    @Phantom proc _copyToArray_loop (i: int, generatedArray: array<Object>): void
    {
        generatedArray[i] = this.storage[i];
    }


    fun *.reduce (@target self: Stream, identity: Object, accumulator: BinaryOperator): Object
    {
        if (accumulator == null || identity == null)
            _throwNPE();

        result = identity;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _accumulate_loop(i, accumulator, result)
        );
    }


    @Phantom proc _accumulate_loop (i: int, accumulator: BinaryOperator, result: Object): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.reduce (@target self: Stream, accumulator: BinaryOperator): Optional
    {
        if (accumulator == null)
            _throwNPE();

        var value: Object = null;

        if (this.length > 0)
        {
            value = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _accumulate_optional_loop(i, accumulator, value)
            );
        }

        result = action DEBUG_DO("Optional.of(value)");
    }


    @Phantom proc _accumulate_optional_loop (i: int, accumulator: BinaryOperator, value: Object): void
    {
        value = action CALL(accumulator, [value, this.storage[i]]);
    }


    fun *.reduce (@target self: Stream, identity:Object, accumulator: BiFunction, combiner: BinaryOperator): Object
    {
        if (accumulator == null || identity == null || combiner == null)
            _throwNPE();

        result = identity;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _accumulate_with_biFunction_loop(i, accumulator, result)
        );
        // since this implementation is always sequential, we do not need to use the combiner
    }


    @Phantom proc _accumulate_with_biFunction_loop (i: int, accumulator: BiFunction, result: Object): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.collect (@target self: Stream, supplier: Supplier, accumulator: BiConsumer, combiner: BiConsumer): Object
    {
        if (supplier == null || accumulator == null || combiner == null)
            _throwNPE();
        // since this implementation is always sequential, we do not need to use the combiner
        result = action CALL(supplier, []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _accumulate_with_biConsumer_loop(i, accumulator, result)
        );

    }


    @Phantom proc _accumulate_with_biConsumer_loop (i: int, accumulator: BiConsumer, result: Object): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.collect (@target self: Stream, collector: Collector): Object
    {
        if (collector == null)
            _throwNPE();

        var i: int = 0;
        val accumulator: BiConsumer = action CALL_METHOD(collector, "accumulator", []);
        action LOOP_FOR(
            i, 0, this.length, +1,
            _accumulate_with_biConsumer_loop(i, collector, result)
        );
    }


    fun *.min (@target self: Stream, comparator: Comparator): Optional
    {
        if (comparator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action DEBUG_DO("Optional.empty()");
        }
        else
        {
            var min: Object = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_min_loop(i, comparator, min)
            );

            result = action DEBUG_DO("Optional.of(min)");
        }
    }


    @Phantom proc _find_min_loop (i: int, comparator: Comparator, min: int): void
    {
        if (action CALL(comparator, [min, this.storage[i]]) > 0)
            min = this.storage[i];
    }


    fun *.max (@target self: Stream, comparator: Comparator): Optional
    {
        if (comparator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action DEBUG_DO("Optional.empty()");
        }
        else
        {
            var max: Object = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_max_loop(i, comparator, max)
            );

            result = action DEBUG_DO("Optional.of(max)");
        }
    }


    @Phantom proc _find_max_loop (i: int, comparator: Comparator, max: int): void
    {
        if (action CALL(comparator, [max, this.storage[i]]) < 0)
            max = this.storage[i];
    }


    fun *.count (@target self: Stream): long
    {
        result = this.length;
    }


    fun *.anyMatch (@target self: Stream, predicate: Predicate): boolean
    {
        if (predicate == null)
            _throwNPE();

        result = false;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _anyMatch_loop(i, predicate, result)
        );
    }


    @Phantom proc _anyMatch_loop (i: int, predicate: Predicate, result: boolean): void
    {
        if (action CALL(predicate, [this.storage[i]]))
        {
            result = true;
            action LOOP_BREAK();
        }
    }


    fun *.allMatch (@target self: Stream, predicate: Predicate): boolean
    {
        if (predicate == null)
            _throwNPE();

        result = true;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _allMatch_loop(i, predicate, result)
        );
    }


    @Phantom proc _allMatch_loop (i: int, predicate: Predicate, result: boolean): void
    {
        if (!action CALL(predicate, [this.storage[i]]))
        {
            result = false;
            action LOOP_BREAK();
        }
    }


    fun *.noneMatch (@target self: Stream, predicate: Predicate): boolean
    {
        if (predicate == null)
            _throwNPE();

        result = true;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _noneMatch_loop(i, predicate, result)
        );
    }


    @Phantom proc _noneMatch_loop (i: int, predicate: Predicate, result: boolean): void
    {
        if (action CALL(predicate, [this.storage[i]]))
        {
            result = false;
            action LOOP_BREAK();
        }
    }


    fun *.findFirst (@target self: Stream): Optional
    {
        result = _findFirst();
    }


    fun *.findAny (@target self: Stream): Optional
    {
        result = _findFirst();
    }

    /*
    @throws(["java.lang.Exception"])
    // within java.lang.AutoCloseable
    fun *.close (@target self: Stream): void
    {
        action TODO();
    }


    @default fun *.dropWhile (@target self: Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.isParallel (@target self: Stream): boolean
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.iterator (@target self: Stream): Iterator
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: Stream, arg0: Runnable): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.parallel (@target self: Stream): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.sequential (@target self: Stream): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.spliterator (@target self: Stream): Spliterator
    {
        action TODO();
    }


    @default fun *.takeWhile (@target self: Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.util.stream.BaseStream
    fun *.unordered (@target self: Stream): BaseStream
    {
        action TODO();
    }
    */
}