libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtDoubleStream.java";

// imports

import java/util/stream/DoubleStream;


// automata

automaton DoubleStreamAutomaton
(
    var storage: array<double>,
    @transient  var length: int,
    var closeHandlers: list<Runnable>
)
: DoubleStreamLSL
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
        mapToInt,
        flatMap,
        sorted,
        distinct,
        peek,
        limit,
        skip,
        /*
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


    proc _actionApply (_action: DoubleConsumer): void
    {
        if (_action == null)
            _throwNPE();

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _actionApply_loop(i, _action)
        );
    }


    @Phantom proc _actionApply_loop (i: int, _action: DoubleConsumer): void
    {
        action CALL(_action, [this.storage[i]]);
    }


    // methods

    fun *.filter (@target self: DoubleStream, predicate: DoublePredicate): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<double> = action ARRAY_NEW("double", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = filteredStorage,
            length = filteredLength,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _filter_loop (i: int, predicate: DoublePredicate, filteredLength: int, filteredStorage: array<double>): void
    {
        if (action CALL(predicate, [this.storage[i]]))
        {
            filteredStorage[filteredLength] = this.storage[i];
            filteredLength += 1;
        }
    }


    fun *.map (@target self: DoubleStream, mapper: DoubleUnaryOperator): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        var mappedStorage: array<double> = action ARRAY_NEW("double", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapped_loop(i, mapper, mappedStorage)
        );

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mappedStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    @Phantom proc _mapped_loop (i: int, mapper: DoubleUnaryOperator, mappedStorage: array<double>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToObj (@target self: DoubleStream, mapper: IntFunction): Stream
    {
        action TODO();
    }


    fun *.mapToLong (@target self: DoubleStream, mapper: DoubleToLongFunction): LongStream
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


    @Phantom proc _mapToLong_loop (i: int, mapper: DoubleToLongFunction, mappedStorage: array<long>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToInt (@target self: DoubleStream, mapper: DoubleToIntFunction): IntStream
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


    @Phantom proc _mapToInt_loop (i: int, mapper: DoubleToIntFunction, mappedStorage: array<int>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: DoubleStream, mapper: DoubleFunction): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);

        this.linkedOrConsumed = true;
    }


    fun *.sorted (@target self: DoubleStream): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (this.length == 0)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
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

            result = new DoubleStreamAutomaton(state = Initialized,
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
        val a: double = this.storage[idxA];
        val b: double = this.storage[idxB];

        if (a > b)
        {
            this.storage[idxA] = b;
            this.storage[idxB] = a;
        }
    }


    fun *.distinct (@target self: DoubleStream): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        var distinctStorage: array<double> = null;
        var distinctLength: int = 0;

        val size: int = this.length;
        if (size == 0)
        {
            distinctStorage = action ARRAY_NEW("double", 0);
            distinctLength = 0;
        }
        else
        {
            val items: array<double> = this.storage;
            action ASSUME(items != null);
            action ASSUME(action ARRAY_SIZE(items) != 0);
            action ASSUME(size == action ARRAY_SIZE(items));
            var i: int = 0;
            var j: int = 0;

            // serialize stored items
            val uniqueItems: list<Double> = action LIST_NEW();
            val visited: map<Double, Double> = action MAP_NEW();
            action LOOP_FOR(
                i, 0, size, +1,
                distinct_loopStoreItems(i, items, visited, j, uniqueItems)
            );

            // allocate space for unique items
            distinctLength = j;
            action ASSUME(distinctLength > 0);
            action ASSUME(distinctLength <= size);
            distinctStorage = action ARRAY_NEW("double", distinctLength);

            // restore unique items back
            action LOOP_FOR(
                i, 0, distinctLength, +1,
                distinct_loopRecoverItems(i, uniqueItems, distinctStorage)
            );
        }

        // return a new instance
        result = new DoubleStreamAutomaton(state = Initialized,
            storage = distinctStorage,
            length = distinctLength,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<double>, visited: map<Double, Double>, j: int, uniqueItems: list<Double>): void
    {
        val item: double = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, STREAM_VALUE);
            action LIST_INSERT_AT(uniqueItems, j, item);
            j += 1;
        }
    }

    @Phantom proc distinct_loopRecoverItems (i: int, uniqueItems: list<Double>, distinctStorage: array<double>): void
    {
        distinctStorage[i] = action LIST_GET(uniqueItems, i);
    }


    fun *.peek (@target self: Stream, _action: DoubleConsumer): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        _actionApply(_action);

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        this.linkedOrConsumed = true;
    }


    fun *.limit (@target self: DoubleStream, maxSize: long): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (maxSize < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSize == 0)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSize > this.length)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
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
            val limitStorage: array<double> = action ARRAY_NEW("double", maxSizeInt);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, maxSizeInt, +1,
                _limit_loop(i, limitStorage)
            );

            result = new DoubleStreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _limit_loop (i: int, limitStorage: array<double>): void
    {
        limitStorage[i] = this.storage[i];
    }


    fun *.skip (@target self: DoubleStream, n: long): DoubleStream
    {
        if (this.linkedOrConsumed)
            _throwISE();

        if (n < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (n == 0)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (n >= this.length)
        {
            var newArray: array<double> = action ARRAY_NEW("double", 0);
            result = new DoubleStreamAutomaton(state = Initialized,
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
            val skipStorage: array<double> = action ARRAY_NEW("double", newLength);

            var i: int = 0;
            var skipIndex: int = 0;
            action LOOP_FOR(
                i, offset, this.length, +1,
                _skip_loop(i, skipIndex, skipStorage)
            );

            result = new DoubleStreamAutomaton(state = Initialized,
                storage = skipStorage,
                length = newLength,
                closeHandlers = this.closeHandlers,
            );
        }

        this.linkedOrConsumed = true;
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<double>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }

}