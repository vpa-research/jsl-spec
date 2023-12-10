libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtStream.java";

// imports

import java/lang/Object;
import java/lang/Runnable;
import java/util/Comparator;
import java/util/Iterator;
import java/util/Optional;
import java/util/Spliterator;
import java/util/function/BiConsumer;
import java/util/function/BiFunction;
import java/util/function/BinaryOperator;
import java/util/function/Consumer;
import java/util/function/Function;
import java/util/function/IntFunction;
import java/util/function/Predicate;
import java/util/function/Supplier;
import java/util/function/ToDoubleFunction;
import java/util/function/ToIntFunction;
import java/util/function/ToLongFunction;
import java/util/stream/BaseStream;
import java/util/stream/Collector;
import java/util/stream/DoubleStream;
import java/util/stream/IntStream;
import java/util/stream/LongStream;

import java/util/stream/Stream;
import java/util/Spliterators;


// automata

automaton StreamAutomaton
(
    var storage: array<Object>,
    @transient var length: int,
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
    var linkedOrConsumed: boolean = false;

    // utilities

    @AutoInline @Phantom proc _checkConsumed (): void
    {
        if (this.linkedOrConsumed)
            _throwISE();
    }


    @AutoInline @Phantom proc _consume (): void
    {
        this.linkedOrConsumed = true;
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwISE (): void
    {
        action THROW_NEW("java.lang.IllegalStateException", []);
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
            result = action CALL_METHOD(null as Optional, "empty", []);
        }
        else
        {
            val first: Object = this.storage[0];
            result = action CALL_METHOD(null as Optional, "ofNullable", [first]);
        }
    }


    // methods

    fun *.filter (@target self: Stream, predicate: Predicate): Stream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        action ASSUME(filteredLength <= this.length);

        var resultStorage: array<Object> = action ARRAY_NEW("java.lang.Object", filteredLength);
        action ARRAY_COPY(filteredStorage, 0, resultStorage, 0, filteredLength);

        result = new StreamAutomaton(state = Initialized,
            storage = resultStorage,
            length = filteredLength,
            closeHandlers = this.closeHandlers,
        );

        _consume();
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
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapped_loop (i: int, mapper: Function, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToInt (@target self: Stream, mapper: ToIntFunction): IntStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        val mappedStorage: array<int> = action ARRAY_NEW("int", this.length);

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

        _consume();
    }


    @Phantom proc _mapToInt_loop (i: int, mapper: ToIntFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToLong (@target self: Stream, mapper: ToLongFunction): LongStream
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapToLong_loop (i: int, mapper: ToLongFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: Stream, mapper: ToDoubleFunction): DoubleStream
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapToDouble_loop (i: int, mapper: ToDoubleFunction, mappedStorage: array<Object>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: Stream, mapper: Function): Stream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.flatMapToInt (@target self: Stream, mapper: Function): IntStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.flatMapToLong (@target self: Stream, mapper: Function): LongStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.flatMapToDouble (@target self: Stream, mapper: Function): DoubleStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here

        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.distinct (@target self: Stream): Stream
    {
        _checkConsumed();

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

        _consume();
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<Object>, visited: map<Object, Object>, j: int, uniqueItems: list<Object>): void
    {
        val item: Object = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, SOMETHING);
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
        _checkConsumed();

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

            action ASSUME(this.length > 0);

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

        _consume();
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
        _checkConsumed();

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

        _consume();
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
        _checkConsumed();

        _actionApply(_action);

        result = new StreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    // maxSize: long - what to do with this ? Array
    fun *.limit (@target self: Stream, maxSize: long): Stream
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _limit_loop (i: int, limitStorage: array<Object>): void
    {
        limitStorage[i] = this.storage[i];
    }


    fun *.skip (@target self: Stream, n: long): Stream
    {
        val offset: int = n as int;

        _checkConsumed();

        if (offset < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (offset == 0)
        {
            result = new StreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (offset >= this.length)
        {
            var newArray: array<Object> = [];
            result = new StreamAutomaton(state = Initialized,
                storage = newArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
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

        _consume();
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<Object>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }


    fun *.forEach (@target self: Stream, _action: Consumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.forEachOrdered (@target self: Stream, _action: Consumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.toArray (@target self: Stream): array<Object>
    {
        _checkConsumed();

        result = this.storage;
        _consume();
    }


    fun *.toArray (@target self: Stream, generator: IntFunction): array<Object>
    {
        _checkConsumed();

        val generatedArray: array<Object> = action CALL(generator,[this.length]) as array<Object>;

        action ARRAY_COPY(this.storage, 0, generatedArray, 0, this.length);

        result = generatedArray;
        _consume();
    }


    fun *.reduce (@target self: Stream, identity: Object, accumulator: BinaryOperator): Object
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _accumulate_loop (i: int, accumulator: BinaryOperator, result: Object): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.reduce (@target self: Stream, accumulator: BinaryOperator): Optional
    {
        _checkConsumed();

        if (accumulator == null)
            _throwNPE();

        var value: Object = null;

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as Optional, "empty", []);
        }
        else if (this.length > 0)
        {
            value = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _accumulate_optional_loop(i, accumulator, value)
            );

            result = action CALL_METHOD(null as Optional, "ofNullable", [value]);
        }

        _consume();
    }


    @Phantom proc _accumulate_optional_loop (i: int, accumulator: BinaryOperator, value: Object): void
    {
        value = action CALL(accumulator, [value, this.storage[i]]);
    }


    fun *.reduce (@target self: Stream, identity:Object, accumulator: BiFunction, combiner: BinaryOperator): Object
    {
        _checkConsumed();

        if (accumulator == null)
            _throwNPE();

        if (combiner == null)
            _throwNPE();

        result = identity;

        if (this.length != 0)
        {
            action ASSUME(this.length > 0);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _accumulate_with_biFunction_loop(i, accumulator, result)
            );
        }
        // UtBot note: since this implementation is always sequential, we do not need to use the combiner

        _consume();
    }


    @Phantom proc _accumulate_with_biFunction_loop (i: int, accumulator: BiFunction, result: Object): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.collect (@target self: Stream, supplier: Supplier, accumulator: BiConsumer, combiner: BiConsumer): Object
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _accumulate_with_biConsumer_loop (i: int, accumulator: BiConsumer, result: Object): void
    {
        action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.collect (@target self: Stream, collector: Collector): Object
    {
        _checkConsumed();

        if (collector == null)
            _throwNPE();

        var i: int = 0;
        val accumulator: BiConsumer = action CALL_METHOD(collector, "accumulator", []);
        action LOOP_FOR(
            i, 0, this.length, +1,
            _accumulate_with_biConsumer_loop(i, collector, result)
        );

        _consume();
    }


    fun *.min (@target self: Stream, comparator: Comparator): Optional
    {
        _checkConsumed();

        if (comparator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as Optional, "empty", []);
        }
        else
        {
            var min: Object = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_min_loop(i, comparator, min)
            );

            result = action CALL_METHOD(null as Optional, "ofNullable", [min]);
        }

        _consume();
    }


    @Phantom proc _find_min_loop (i: int, comparator: Comparator, min: Object): void
    {
        if (action CALL(comparator, [min, this.storage[i]]) > 0)
            min = this.storage[i];
    }


    fun *.max (@target self: Stream, comparator: Comparator): Optional
    {
        _checkConsumed();

        if (comparator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as Optional, "empty", []);
        }
        else
        {
            var max: Object = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_max_loop(i, comparator, max)
            );

            result = action CALL_METHOD(null as Optional, "ofNullable", [max]);
        }

        _consume();
    }


    @Phantom proc _find_max_loop (i: int, comparator: Comparator, max: Object): void
    {
        if (action CALL(comparator, [max, this.storage[i]]) < 0)
            max = this.storage[i];
    }


    fun *.count (@target self: Stream): long
    {
        _checkConsumed();

        result = this.length;
        _consume();
    }


    fun *.anyMatch (@target self: Stream, predicate: Predicate): boolean
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _predicate_condition_increment_loop (i: int): void
    {
        i += 1;
    }


    fun *.allMatch (@target self: Stream, predicate: Predicate): boolean
    {
        _checkConsumed();

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

        _consume();
    }


    fun *.noneMatch (@target self: Stream, predicate: Predicate): boolean
    {
        _checkConsumed();

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

        _consume();
    }


    fun *.findFirst (@target self: Stream): Optional
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.findAny (@target self: Stream): Optional
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.iterator (@target self: Stream): Iterator
    {
        _checkConsumed();

        result = new StreamIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0
        );

        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.spliterator (@target self: Stream): Spliterator
    {
        _checkConsumed();

        result = new Spliterators_ArraySpliteratorAutomaton(state = Initialized,
            array = this.storage,
            index = 0,
            fence = this.length,
            characteristics = SPLITERATOR_ORDERED | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );

        _consume();
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
        _checkConsumed();
        result = new StreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );
        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: Stream, arg0: Runnable): BaseStream
    {
        // #todo: make chain of the runnable's like in the original method (java.util.stream.AbstractPipeline#onClose)
        _checkConsumed();

        val listLength: int = action LIST_SIZE(this.closeHandlers);
        action LIST_INSERT_AT(this.closeHandlers, listLength, arg0);
        result = self;
    }


    // within java.lang.AutoCloseable
    fun *.close (@target self: Stream): void
    {
        val listLength: int = action LIST_SIZE(this.closeHandlers);

        // UtBot note: this implementation does not care about suppressing and throwing exceptions produced by handlers
        var i: int = 0;
        action LOOP_FOR(
            i, 0, listLength, +1,
            _closeHandlers_loop(i)
        );

        this.closeHandlers = action LIST_NEW();

        _consume();
    }


    @Phantom proc _closeHandlers_loop (i: int): void
    {
        val currentHandler: Runnable = action LIST_GET(this.closeHandlers, i) as Runnable;
        action CALL(currentHandler, []);
    }


    fun *.dropWhile (@target self: Stream, predicate: Predicate): Stream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<Object> = action ARRAY_NEW("java.lang.Object", 0);
            result = new StreamAutomaton(state = Initialized,
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

        _consume();
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


    fun *.takeWhile (@target self: Stream, predicate: Predicate): Stream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<Object> = action ARRAY_NEW("java.lang.Object", 0);
            result = new StreamAutomaton(state = Initialized,
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

        _consume();
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