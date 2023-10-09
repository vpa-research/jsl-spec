libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtIntStream.java";

// imports

import java/util/stream/IntStream;


// automata

automaton IntStreamAutomaton
(
    var storage: array<int>,
    @transient  var length: int,
    var closeHandlers: list<Runnable>
)
: IntStreamLSL
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
        mapToObj,
        mapToLong,
        mapToDouble,
        flatMap,
        sorted,
        distinct,
        peek,
        limit,
        skip,
        forEach,
        forEachOrdered,
        toArray,
        reduce (IntStream, int, IntBinaryOperator),
        reduce (IntStream, IntBinaryOperator),
        collect,
        min,
        max,
        count,
        anyMatch,
        allMatch,
        noneMatch,
        findFirst,
        findAny,
        //iterator,
        //spliterator,
        isParallel,
        sequential,
        parallel,
        unordered,
        onClose,
        close,
        dropWhile,
        takeWhile,
        asDoubleStream,
        asLongStream,
        sum,
        /*
        average,
        boxed,
        summaryStatistics,*/
    ];

    // internal variables

    // #problem Can we have parallel streams ? Or not ?
    var isParallel: boolean = false;
    var linkedOrConsumed: boolean = false;

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwISE (): void
    {
        action THROW_NEW("java.lang.IllegalStateException", []);
    }


    proc _actionApply (_action: IntConsumer): void
    {
        if (_action == null)
            _throwNPE();

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _actionApply_loop(i, _action)
        );
    }


    @Phantom proc _actionApply_loop (i: int, _action: IntConsumer): void
    {
        action CALL(_action, [this.storage[i]]);
    }


    proc _findFirst (): OptionalInt
    {
        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalInt.empty()");
        }
        else
        {
            val first: int = this.storage[0];
            result = action DEBUG_DO("OptionalInt.ofNullable(first)");
        }
    }


    // methods

    fun *.filter (@target self: IntStream, predicate: IntPredicate): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<int> = action ARRAY_NEW("int", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = filteredStorage,
            length = filteredLength,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _filter_loop (i: int, predicate: IntPredicate, filteredLength: int, filteredStorage: array<int>): void
    {
        if (action CALL(predicate, [this.storage[i]]))
        {
            filteredStorage[filteredLength] = this.storage[i];
            filteredLength += 1;
        }
    }


    fun *.map (@target self: IntStream, mapper: IntUnaryOperator): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<int> = action ARRAY_NEW("int", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapped_loop(i, mapper, mappedStorage)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapped_loop (i: int, mapper: IntUnaryOperator, mappedStorage: array<int>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToObj (@target self: IntStream, mapper: IntFunction): Stream
    {
        action TODO();
    }


    fun *.mapToLong (@target self: IntStream, mapper: IntToLongFunction): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<long> = action ARRAY_NEW("long", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToLong_loop(i, mapper, mappedStorage)
        );

        result = new LongStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapToLong_loop (i: int, mapper: IntToLongFunction, mappedStorage: array<long>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: IntStream, mapper: IntToDoubleFunction): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<double> = action ARRAY_NEW("double", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToDouble_loop(i, mapper, mappedStorage)
        );

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapToDouble_loop (i: int, mapper: IntToDoubleFunction, mappedStorage: array<double>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: IntStream, mapper: IntFunction): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);

        this.linkedOrConsumed = true;
    }


    fun *.sorted (@target self: IntStream): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (this.length == 0)
        {
            result = new IntStreamAutomaton(state = Initialized,
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

            result = new IntStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
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
        val a: int = this.storage[idxA];
        val b: int = this.storage[idxB];

        if (a > b)
        {
            this.storage[idxA] = b;
            this.storage[idxB] = a;
        }
    }


    fun *.distinct (@target self: IntStream): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        var distinctStorage: array<int> = null;
        var distinctLength: int = 0;

        val size: int = this.length;
        if (size == 0)
        {
            distinctStorage = action ARRAY_NEW("int", 0);
            distinctLength = 0;
        }
        else
        {
            val items: array<int> = this.storage;
            action ASSUME(items != null);
            action ASSUME(action ARRAY_SIZE(items) != 0);
            action ASSUME(size == action ARRAY_SIZE(items));
            var i: int = 0;
            var j: int = 0;

            // serialize stored items
            val uniqueItems: list<Integer> = action LIST_NEW();
            val visited: map<Integer, Integer> = action MAP_NEW();
            action LOOP_FOR(
                i, 0, size, +1,
                distinct_loopStoreItems(i, items, visited, j, uniqueItems)
            );

            // allocate space for unique items
            distinctLength = j;
            action ASSUME(distinctLength > 0);
            action ASSUME(distinctLength <= size);
            distinctStorage = action ARRAY_NEW("int", distinctLength);

            // restore unique items back
            action LOOP_FOR(
                i, 0, distinctLength, +1,
                distinct_loopRecoverItems(i, uniqueItems, distinctStorage)
            );
        }

        // return a new instance
        result = new IntStreamAutomaton(state = Initialized,
            storage = distinctStorage,
            length = distinctLength,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<int>, visited: map<Integer, Integer>, j: int, uniqueItems: list<Integer>): void
    {
        val item: int = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, STREAM_VALUE);
            action LIST_INSERT_AT(uniqueItems, j, item);
            j += 1;
        }
    }

    @Phantom proc distinct_loopRecoverItems (i: int, uniqueItems: list<Integer>, distinctStorage: array<int>): void
    {
        distinctStorage[i] = action LIST_GET(uniqueItems, i);
    }


    fun *.peek (@target self: IntStream, _action: IntConsumer): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);

        result = new IntStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    fun *.limit (@target self: IntStream, maxSize: long): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (maxSize < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSize == 0)
        {
            result = new IntStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSize > this.length)
        {
            result = new IntStreamAutomaton(state = Initialized,
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
            val limitStorage: array<int> = action ARRAY_NEW("int", maxSizeInt);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, maxSizeInt, +1,
                _limit_loop(i, limitStorage)
            );

            result = new IntStreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _limit_loop (i: int, limitStorage: array<int>): void
    {
        limitStorage[i] = this.storage[i];
    }


    fun *.skip (@target self: IntStream, n: long): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (n < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (n == 0)
        {
            result = new IntStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (n >= this.length)
        {
            var newArray: array<int> = action ARRAY_NEW("int", 0);
            result = new IntStreamAutomaton(state = Initialized,
                storage = newArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            // what will be if will be overflow ?
            val offset: int = n as int;
            val newLength: int = this.length - offset;
            val skipStorage: array<int> = action ARRAY_NEW("int", newLength);

            var i: int = 0;
            var skipIndex: int = 0;
            action LOOP_FOR(
                i, offset, this.length, +1,
                _skip_loop(i, skipIndex, skipStorage)
            );

            result = new IntStreamAutomaton(state = Initialized,
                storage = skipStorage,
                length = newLength,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<int>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }

    fun *.forEach (@target self: IntStream, _action: IntConsumer): void
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);
        this.linkedOrConsumed = true;
    }


    fun *.forEachOrdered (@target self: IntStream, _action: IntConsumer): void
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);
        this.linkedOrConsumed = true;
    }


    fun *.toArray (@target self: IntStream): array<int>
    {
        if (this.linkedOrConsumed)
            _throwISE();

        result = this.storage;
        this.linkedOrConsumed = true;
    }


    fun *.reduce (@target self: IntStream, identity: int, accumulator: IntBinaryOperator): int
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (accumulator == null)
            _throwNPE();

        result = identity;

        if (this.length != 0)
        {
            action ASSUME(this.length > 0);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _accumulate_loop(i, accumulator, result)
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _accumulate_loop (i: int, accumulator: IntBinaryOperator, result: int): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.reduce (@target self: IntStream, accumulator: IntBinaryOperator): OptionalInt
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (accumulator == null)
            _throwNPE();

        var value: int = 0;

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalInt.empty()");
        }
        else if (this.length > 0)
        {
            value = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _accumulate_optional_loop(i, accumulator, value)
            );

            result = action DEBUG_DO("OptionalInt.ofNullable(value)");
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _accumulate_optional_loop (i: int, accumulator: IntBinaryOperator, value: int): void
    {
        value = action CALL(accumulator, [value, this.storage[i]]);
    }


    fun *.collect (@target self: IntStream, supplier: Supplier, accumulator: ObjIntConsumer, combiner: BiConsumer): Object
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (supplier == null)
            _throwNPE();

        if (accumulator == null)
            _throwNPE();

        if (combiner == null)
            _throwNPE();

        // UtBot note: since this implementation is always sequential, we do not need to use the combiner
        result = action CALL(supplier, []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _accumulate_with_biConsumer_loop(i, accumulator, result)
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _accumulate_with_biConsumer_loop (i: int, accumulator: ObjIntConsumer, result: Object): void
    {
        action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.min (@target self: IntStream): OptionalInt
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalInt.empty()");
        }
        else
        {
            var min: double = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_min_loop(i, min)
            );

            result = action DEBUG_DO("OptionalInt.ofNullable(min)");
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _find_min_loop (i: int, min: int): void
    {
        if (min < this.storage[i])
            min = this.storage[i];
    }


    fun *.max (@target self: IntStream): OptionalInt
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalInt.empty()");
        }
        else
        {
            var max: int = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_max_loop(i, max)
            );

            result = action DEBUG_DO("OptionalInt.ofNullable(max)");
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _find_max_loop (i: int, max: int): void
    {
        if (max > this.storage[i])
            max = this.storage[i];
    }


    fun *.count (@target self: IntStream): long
    {
        if (this.linkedOrConsumed)
            _throwISE();

        result = this.length;
        this.linkedOrConsumed = true;
    }


    fun *.anyMatch (@target self: IntStream, predicate: IntPredicate): boolean
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        result = false;

        var i: int = 0;
        action LOOP_WHILE(
            i < this.length && !action CALL(predicate, [this.storage[i]]),
            _predicate_condition_increment_loop(i)
        );

        if (i < this.length)
            result = true;

        this.linkedOrConsumed = true;
    }


    @Phantom proc _predicate_condition_increment_loop (i: int): void
    {
        i += 1;
    }


    fun *.allMatch (@target self: IntStream, predicate: IntPredicate): boolean
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        result = true;

        if (this.length > 0)
        {
            result = false;
            var i: int = 0;
            action LOOP_WHILE(
                i < this.length && action CALL(predicate, [this.storage[i]]),
                _predicate_condition_increment_loop(i)
            );

            if (i == this.length)
                result = true;
        }

        this.linkedOrConsumed = true;
    }


    fun *.noneMatch (@target self: IntStream, predicate: IntPredicate): boolean
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        result = true;

        if (this.length > 0)
        {
            result = false;
            var i: int = 0;
            action LOOP_WHILE(
                i < this.length && !action CALL(predicate, [this.storage[i]]),
                _predicate_condition_increment_loop(i)
            );

            if (i == this.length)
                result = true;
        }

        this.linkedOrConsumed = true;
    }


    fun *.findFirst (@target self: IntStream): OptionalInt
    {
        if (this.linkedOrConsumed)
            _throwISE();

        result = _findFirst();
        this.linkedOrConsumed = true;
    }


    fun *.findAny (@target self: IntStream): OptionalInt
    {
        if (this.linkedOrConsumed)
            _throwISE();

        result = _findFirst();
        this.linkedOrConsumed = true;
    }


    /*fun *.iterator (@target self: IntStream): PrimitiveIterator.OfInt
    {
        action TODO();
    }


    fun *.spliterator (@target self: IntStream): Spliterator.OfInt
    {
        action TODO();
    }*/


    // within java.util.stream.BaseStream
    fun *.isParallel (@target self: IntStream): boolean
    {
        result = this.isParallel;
    }


    fun *.sequential (@target self: IntStream): IntStream
    {
        this.isParallel = false;
        result = self;
    }


    fun *.parallel (@target self: IntStream): IntStream
    {
        this.isParallel = true;
        result = self;
    }


    fun *.unordered (@target self: IntStream): IntStream
    {
        result = self;
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: IntStream, arg0: Runnable): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        val listLength: int = action LIST_SIZE(this.closeHandlers);
        action LIST_INSERT_AT(this.closeHandlers, listLength, arg0);
        result = self;
    }


    // within java.lang.AutoCloseable
    fun *.close (@target self: IntStream): void
    {
        val listLength: int = action LIST_SIZE(this.closeHandlers);

        // UtBot note: this implementation does not care about suppressing and throwing exceptions produced by handlers
        var i: int = 0;
        action LOOP_FOR(
            i, 0, listLength, +1,
            _closeHandlers_loop(i)
        );

        this.closeHandlers = action LIST_NEW();

        this.linkedOrConsumed = true;
    }


    @Phantom proc _closeHandlers_loop (i: int): void
    {
        val currentHandler: Runnable = action LIST_GET(this.closeHandlers, i) as Runnable;
        action CALL(currentHandler, []);
    }


    fun *.dropWhile (@target self: IntStream, predicate: IntPredicate): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<int> = action ARRAY_NEW("int", 0);
            result = new IntStreamAutomaton(state = Initialized,
                storage = emptyStorage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            var dropLength: int = 0;

            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _dropWhile_loop(i, dropLength, predicate)
            );

            val newLength: int = this.length - dropLength;
            val newStorage: array<int> = action ARRAY_NEW("int", newLength);

            var j: int = 0;
            action LOOP_FOR(
                i, dropLength, this.length, +1,
                _copy_dropWhile_loop(i, j, newStorage)
            );

            result = new IntStreamAutomaton(state = Initialized,
                storage = newStorage,
                length = newLength,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _dropWhile_loop (i: int, dropLength: int, predicate: IntPredicate): void
    {
        if (action CALL(predicate, [this.storage[i]]))
            dropLength += 1;
        else
            action LOOP_BREAK();
    }


    @Phantom proc _copy_dropWhile_loop (i: int, j: int, newStorage: array<int>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
    }


    fun *.takeWhile (@target self: IntStream, predicate: IntPredicate): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<int> = action ARRAY_NEW("int", 0);
            result = new IntStreamAutomaton(state = Initialized,
                storage = emptyStorage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            var takeLength: int = 0;

            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _takeWhile_loop(i, takeLength, predicate)
            );

            val newLength: int = takeLength;
            val newStorage: array<int> = action ARRAY_NEW("int", newLength);

            var j: int = 0;
            action LOOP_FOR(
                i, 0, takeLength, +1,
                _copy_takeWhile_loop(i, j, newStorage)
            );

            result = new IntStreamAutomaton(state = Initialized,
                storage = newStorage,
                length = newLength,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _takeWhile_loop (i: int, takeLength: int, predicate: IntPredicate): void
    {
        if (action CALL(predicate, [this.storage[i]]))
            takeLength += 1;
        else
            action LOOP_BREAK();
    }


    @Phantom proc _copy_takeWhile_loop (i: int, j: int, newStorage: array<int>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
    }


    fun *.asLongStream (@target self: IntStream): LongStream
    {
        if (this.length == 0)
        {
            val emptyArray: array<long> = action ARRAY_NEW("long", 0);
            result = new LongStreamAutomaton(state = Initialized,
                storage = emptyArray,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            val newStorage: array<long> = action ARRAY_NEW("long", this.length);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _convertIntStorageToLong_loop(i, newStorage)
            );

            result = new LongStreamAutomaton(state = Initialized,
                storage = newStorage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
    }


    @Phantom proc _convertIntStorageToLong_loop(i: int, newStorage: array<long>): void
    {
        newStorage[i] = this.storage[i] as long;
    }


    fun *.asDoubleStream (@target self: IntStream): DoubleStream
    {
        if (this.length == 0)
        {
            val emptyArray: array<double> = action ARRAY_NEW("double", 0);
            result = new IntStreamAutomaton(state = Initialized,
                storage = emptyArray,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            val newStorage: array<double> = action ARRAY_NEW("double", this.length);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _convertIntStorageToDouble_loop(i, newStorage)
            );

            result = new DoubleStreamAutomaton(state = Initialized,
                storage = newStorage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
    }


    @Phantom proc _convertIntStorageToDouble_loop(i: int, newStorage: array<double>): void
    {
        newStorage[i] = this.storage[i] as double;
    }


    fun *.sum (@target self: IntStream): int
    {
        result = 0;

        if (this.length != 0)
        {
            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _sum_loop(i, result)
            );
        }
    }


    @Phantom proc _sum_loop (i: int, result: int): void
    {
        result += this.storage[i];
    }
}