libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/stream/Stream.java";

// imports

import java/util/stream/Stream;


// automata

automaton StreamAutomaton
(
    var storage: array<Object>,
    @transient  var length: int,
    var closeHandlers: list<Runnable>
)
: StreamLSL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
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
        iterator,
        spliterator,
        isParallel,
        sequential,
        parallel,
        unordered,
        onClose,
        close,
        dropWhile,
        takeWhile,
    ];

    // internal variables

    // #problem Can we have parallel streams ? Or not ?
    var isParallel: boolean = false;

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _actionApply (_action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _actionApply_loop(i, _action)
        );
    }


    @Phantom proc _actionApply_loop (i: int, _action: Consumer): void
    {
        action CALL(_action, [this.storage[i]]);
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
            closeHandlers = this.closeHandlers,
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
            closeHandlers = this.closeHandlers,
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

        val mappedStorage: array<int> = action ARRAY_NEW("int", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToInt_loop(i, mapper, mappedStorage)
        );

        // #todo: Temporary decision (we don't have IntStream automaton at this moment)
        result = action DEBUG_DO("java.util.Arrays.stream(mappedStorage)");
    }


    @Phantom proc _mapToInt_loop (i: int, mapper: ToIntFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToLong (@target self: Stream, mapper: ToLongFunction): LongStream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<long> = action ARRAY_NEW("long", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToLong_loop(i, mapper, mappedStorage)
        );

        // #todo: Temporary decision (we don't have IntStream automaton at this moment)
        result = action DEBUG_DO("java.util.Arrays.stream(mappedStorage)");
    }


    @Phantom proc _mapToLong_loop (i: int, mapper: ToLongFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: Stream, mapper: ToDoubleFunction): DoubleStream
    {
        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<double> = action ARRAY_NEW("double", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToDouble_loop(i, mapper, mappedStorage)
        );

        // #todo: Temporary decision (we don't have IntStream automaton at this moment)
        result = action DEBUG_DO("java.util.Arrays.stream(mappedStorage)");
    }


    @Phantom proc _mapToDouble_loop (i: int, mapper: ToDoubleFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: Stream, mapper: Function): Stream
    {
        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    fun *.flatMapToInt (@target self: Stream, mapper: Function): IntStream
    {
        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun *.flatMapToLong (@target self: Stream, mapper: Function): LongStream
    {
        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun *.flatMapToDouble (@target self: Stream, mapper: Function): DoubleStream
    {
        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun *.distinct (@target self: Stream): Stream
    {
        var distinctStorage: array<Object> = null;
        var distinctLength: int = 0;

        val size: int = this.length;
        if (size == 0)
        {
            distinctStorage = action ARRAY_NEW("java.lang.Object", 0);
            distinctLength = 0;
        }
        else
        {
            val items: array<Object> = this.storage;
            action ASSUME(items != null);
            action ASSUME(action ARRAY_SIZE(items) != 0);
            action ASSUME(size == action ARRAY_SIZE(items));
            var i: int = 0;
            var j: int = 0;

            // serialize stored items
            val uniqueItems: list<Object> = action LIST_NEW();
            val visited: map<Object, Object> = action MAP_NEW();
            action LOOP_FOR(
                i, 0, size, +1,
                distinct_loopStoreItems(i, items, visited, j, uniqueItems)
            );

            // allocate space for unique items
            distinctLength = j;
            action ASSUME(distinctLength > 0);
            action ASSUME(distinctLength <= size);
            distinctStorage = action ARRAY_NEW("java.lang.Object", distinctLength);

            // restore unique items back
            action LOOP_FOR(
                i, 0, distinctLength, +1,
                distinct_loopRecoverItems(i, uniqueItems, distinctStorage)
            );
        }

        // return a new instance
        result = new StreamAutomaton(state = Initialized,
            storage = distinctStorage,
            length = distinctLength,
            closeHandlers = this.closeHandlers,
        );
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<Object>, visited: map<Object, Object>, j: int, uniqueItems: list<Object>): void
    {
        val item: Object = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, STREAM_VALUE);
            action LIST_INSERT_AT(uniqueItems, j, item);
            j += 1;
        }
    }

    @Phantom proc distinct_loopRecoverItems (i: int, uniqueItems: list<Object>, distinctStorage: array<Object>): void
    {
        distinctStorage[i] = action LIST_GET(uniqueItems, i);
    }


    fun *.sorted (@target self: Stream): Stream
    {
        if (this.length == 0)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
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
                closeHandlers = this.closeHandlers,
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

        if (action CALL_METHOD(a as Comparable, "compareTo", [b]) > 0)
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
                closeHandlers = this.closeHandlers,
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
                closeHandlers = this.closeHandlers,
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

        if (action CALL(comparator, [a, b]) > 0)
        {
            this.storage[idxA] = b;
            this.storage[idxB] = a;
        }
    }


    fun *.peek (@target self: Stream, _action: Consumer): Stream
    {
        _actionApply(_action);

        result = new StreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );
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
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSize > this.length)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
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
                closeHandlers = this.closeHandlers,
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
                closeHandlers = this.closeHandlers,
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
                closeHandlers = this.closeHandlers,
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
        val generatedArray: array<Object> = action CALL(generator,[this.length]) as array<Object>;

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
        action CALL(accumulator, [result, this.storage[i]]);
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


    // within java.util.stream.BaseStream
    fun *.iterator (@target self: Stream): Iterator
    {
        result = new StreamIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0
        );
    }


    // within java.util.stream.BaseStream
    fun *.spliterator (@target self: Stream): Spliterator
    {
        result = action DEBUG_DO("java.util.Spliterators.spliterator(this.storage, Spliterator.ORDERED)");
    }


    // within java.util.stream.BaseStream
    fun *.isParallel (@target self: Stream): boolean
    {
        result = this.isParallel;
    }


    // within java.util.stream.BaseStream
    fun *.sequential (@target self: Stream): BaseStream
    {
        this.isParallel = false;
        result = self;
    }


    // within java.util.stream.BaseStream
    fun *.parallel (@target self: Stream): BaseStream
    {
        this.isParallel = true;
        result = self;
    }


    // within java.util.stream.BaseStream
    fun *.unordered (@target self: Stream): BaseStream
    {
        result = self;
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: Stream, arg0: Runnable): BaseStream
    {
        val listLength: int = action LIST_SIZE(this.closeHandlers);
        action LIST_INSERT_AT(this.closeHandlers, listLength, arg0);
        result = self;
    }


    // within java.lang.AutoCloseable
    fun *.close (@target self: Stream): void
    {
        val listLength: int = action LIST_SIZE(this.closeHandlers);

        // NOTE: this implementation does not care about suppressing and throwing exceptions produced by handlers
        var i: int = 0;
        action LOOP_FOR(
            i, 0, listLength, +1,
            _closeHandlers_loop(i)
        );

        this.closeHandlers = action LIST_NEW();
    }


    @Phantom proc _closeHandlers_loop (i: int): void
    {
        val currentHandler: Runnable = action LIST_GET(this.closeHandlers, i) as Runnable;
        action CALL(currentHandler, []);
    }


    // Do I need @default annotation for this method ?
    fun *.dropWhile (@target self: Stream, predicate: Predicate): Stream
    {
        if (predicate == null)
            _throwNPE();

        var dropLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _dropWhile_loop(i, dropLength, predicate)
        );

        val newLength: int = this.length - dropLength;
        val newStorage: array<Object> = action ARRAY_NEW("java.lang.Object", newLength);

        var j: int = 0;
        action LOOP_FOR(
            i, dropLength, this.length, +1,
            _copy_dropWhile_loop(i, j, newStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = newStorage,
            length = newLength,
            closeHandlers = this.closeHandlers,
        );
    }


    @Phantom proc _dropWhile_loop (i: int, dropLength: int, predicate: Predicate): void
    {
        if (action CALL(predicate, [this.storage[i]]))
            dropLength += 1;
        else
            action LOOP_BREAK();
    }


    @Phantom proc _copy_dropWhile_loop (i: int, j: int, newStorage: array<Object>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
    }


    // Do I need @default annotation for this method ?
    fun *.takeWhile (@target self: Stream, predicate: Predicate): Stream
    {
        if (predicate == null)
            _throwNPE();

        var takeLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _takeWhile_loop(i, takeLength, predicate)
        );

        val newLength: int = takeLength;
        val newStorage: array<Object> = action ARRAY_NEW("java.lang.Object", newLength);

        var j: int = 0;
        action LOOP_FOR(
            i, 0, takeLength, +1,
            _copy_takeWhile_loop(i, j, newStorage)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = newStorage,
            length = newLength,
            closeHandlers = this.closeHandlers,
        );
    }


    @Phantom proc _takeWhile_loop (i: int, takeLength: int, predicate: Predicate): void
    {
        if (action CALL(predicate, [this.storage[i]]))
            takeLength += 1;
        else
            action LOOP_BREAK();
    }


    @Phantom proc _copy_takeWhile_loop (i: int, j: int, newStorage: array<Object>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
    }
}