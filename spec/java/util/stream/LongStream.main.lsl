libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtLongStream.java";

// imports

import java/util/stream/LongStream;


// automata

automaton LongStreamAutomaton
(
    var storage: array<long>,
    @transient  var length: int,
    var closeHandlers: list<Runnable>
)
: LongStreamLSL
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
        mapToInt,
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
        /*
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
        takeWhile,*/
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


    proc _actionApply (_action: LongConsumer): void
    {
        if (_action == null)
            _throwNPE();

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _actionApply_loop(i, _action)
        );
    }


    @Phantom proc _actionApply_loop (i: int, _action: LongConsumer): void
    {
        action CALL(_action, [this.storage[i]]);
    }

    // methods

    fun *.filter (@target self: LongStream, predicate: LongPredicate): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<long> = action ARRAY_NEW("long", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        result = new LongStreamAutomaton(state = Initialized,
            storage = filteredStorage,
            length = filteredLength,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _filter_loop (i: int, predicate: LongPredicate, filteredLength: int, filteredStorage: array<long>): void
    {
        if (action CALL(predicate, [this.storage[i]]))
        {
            filteredStorage[filteredLength] = this.storage[i];
            filteredLength += 1;
        }
    }


    fun *.map (@target self: LongStream, mapper: LongUnaryOperator): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<long> = action ARRAY_NEW("long", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapped_loop(i, mapper, mappedStorage)
        );

        result = new LongStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapped_loop (i: int, mapper: LongUnaryOperator, mappedStorage: array<long>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToObj (@target self: LongStream, mapper: IntFunction): Stream
    {
        action TODO();
    }


    fun *.mapToInt (@target self: LongStream, mapper: LongToIntFunction): IntStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<int> = action ARRAY_NEW("int", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToInt_loop(i, mapper, mappedStorage)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapToInt_loop (i: int, mapper: LongToIntFunction, mappedStorage: array<int>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: LongStream, mapper: LongToDoubleFunction): DoubleStream
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

        result = new IntStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapToDouble_loop (i: int, mapper: LongToDoubleFunction, mappedStorage: array<double>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: LongStream, mapper: LongFunction): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);

        this.linkedOrConsumed = true;
    }


    fun *.sorted (@target self: LongStream): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (this.length == 0)
        {
            result = new LongStreamAutomaton(state = Initialized,
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

            result = new LongStreamAutomaton(state = Initialized,
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
        val a: long = this.storage[idxA];
        val b: long = this.storage[idxB];

        if (a > b)
        {
            this.storage[idxA] = b;
            this.storage[idxB] = a;
        }
    }


    fun *.distinct (@target self: LongStream): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        var distinctStorage: array<long> = null;
        var distinctLength: int = 0;

        val size: int = this.length;
        if (size == 0)
        {
            distinctStorage = action ARRAY_NEW("long", 0);
            distinctLength = 0;
        }
        else
        {
            val items: array<long> = this.storage;
            action ASSUME(items != null);
            action ASSUME(action ARRAY_SIZE(items) != 0);
            action ASSUME(size == action ARRAY_SIZE(items));
            var i: int = 0;
            var j: int = 0;

            // serialize stored items
            val uniqueItems: list<Long> = action LIST_NEW();
            val visited: map<Long, Long> = action MAP_NEW();
            action LOOP_FOR(
                i, 0, size, +1,
                distinct_loopStoreItems(i, items, visited, j, uniqueItems)
            );

            // allocate space for unique items
            distinctLength = j;
            action ASSUME(distinctLength > 0);
            action ASSUME(distinctLength <= size);
            distinctStorage = action ARRAY_NEW("long", distinctLength);

            // restore unique items back
            action LOOP_FOR(
                i, 0, distinctLength, +1,
                distinct_loopRecoverItems(i, uniqueItems, distinctStorage)
            );
        }

        // return a new instance
        result = new LongStreamAutomaton(state = Initialized,
            storage = distinctStorage,
            length = distinctLength,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<long>, visited: map<Long, Long>, j: int, uniqueItems: list<Long>): void
    {
        val item: long = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, STREAM_VALUE);
            action LIST_INSERT_AT(uniqueItems, j, item);
            j += 1;
        }
    }

    @Phantom proc distinct_loopRecoverItems (i: int, uniqueItems: list<Long>, distinctStorage: array<long>): void
    {
        distinctStorage[i] = action LIST_GET(uniqueItems, i);
    }


    fun *.peek (@target self: Stream, _action: LongConsumer): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);

        result = new LongStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    fun *.limit (@target self: LongStream, maxSize: long): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (maxSize < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSize == 0)
        {
            result = new LongStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSize > this.length)
        {
            result = new LongStreamAutomaton(state = Initialized,
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
            val limitStorage: array<long> = action ARRAY_NEW("long", maxSizeInt);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, maxSizeInt, +1,
                _limit_loop(i, limitStorage)
            );

            result = new LongStreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _limit_loop (i: int, limitStorage: array<long>): void
    {
        limitStorage[i] = this.storage[i];
    }


    fun *.skip (@target self: LongStream, n: long): LongStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (n < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (n == 0)
        {
            result = new LongStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (n >= this.length)
        {
            var newArray: array<long> = action ARRAY_NEW("long", 0);
            result = new LongStreamAutomaton(state = Initialized,
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
            val skipStorage: array<long> = action ARRAY_NEW("long", newLength);

            var i: int = 0;
            var skipIndex: int = 0;
            action LOOP_FOR(
                i, offset, this.length, +1,
                _skip_loop(i, skipIndex, skipStorage)
            );

            result = new LongStreamAutomaton(state = Initialized,
                storage = skipStorage,
                length = newLength,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<long>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }


    fun *.forEach (@target self: LongStream, _action: LongConsumer): void
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);
        this.linkedOrConsumed = true;
    }


    fun *.forEachOrdered (@target self: LongStream, _action: LongConsumer): void
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);
        this.linkedOrConsumed = true;
    }


    fun *.toArray (@target self: LongStream): array<long>
    {
        if (this.linkedOrConsumed)
            _throwISE();

        result = this.storage;
        this.linkedOrConsumed = true;
    }
}