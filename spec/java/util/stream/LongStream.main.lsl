libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtLongStream.java";

// imports

import java/util/stream/LongStream;
import java/lang/Long;
import java/util/function/LongFunction;
import java/util/function/LongPredicate;
import java/util/function/LongUnaryOperator;
import java/util/function/LongToDoubleFunction;
import java/util/function/LongToIntFunction;
import java/util/function/LongBinaryOperator;
import java/util/function/ObjLongConsumer;
import java/util/LongSummaryStatistics;
import java/util/PrimitiveIterator;


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

    initstate Initialized;

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
        reduce (LongStream, long, LongBinaryOperator),
        reduce (LongStream, LongBinaryOperator),
        collect,
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
        asDoubleStream,
        sum,
        average,
        summaryStatistics,
        boxed,
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


    proc _findFirst (): OptionalLong
    {
        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalLong.empty()");
        }
        else
        {
            val first: long = this.storage[0];
            result = action DEBUG_DO("OptionalLong.of(first)");
        }
    }


    proc _sum (): long
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


    @Phantom proc _sum_loop (i: int, result: long): void
    {
        result += this.storage[i];
    }

    // methods

    fun *.filter (@target self: LongStream, predicate: LongPredicate): LongStream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<long> = action ARRAY_NEW("long", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        action ASSUME(filteredLength <= this.length);

        var resultStorage: array<long> = action ARRAY_NEW("long", filteredLength);
        action ARRAY_COPY(filteredStorage, 0, resultStorage, 0, filteredLength);

        result = new LongStreamAutomaton(state = Initialized,
            storage = resultStorage,
            length = filteredLength,
            closeHandlers = this.closeHandlers,
        );

        _consume();
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
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapped_loop (i: int, mapper: LongUnaryOperator, mappedStorage: array<long>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToObj (@target self: LongStream, mapper: LongFunction): Stream
    {
        _checkConsumed();

        // UtBot note: Here we assume that this mapping does not produce infinite streams
        val objStorage: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _mapToObj_loop(i, objStorage, mapper)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = objStorage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    @Phantom proc _mapToObj_loop (i: int, objStorage: array<Object>, mapper: LongFunction): void
    {
        objStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToInt (@target self: LongStream, mapper: LongToIntFunction): IntStream
    {
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapToInt_loop (i: int, mapper: LongToIntFunction, mappedStorage: array<int>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: LongStream, mapper: LongToDoubleFunction): DoubleStream
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


    @Phantom proc _mapToDouble_loop (i: int, mapper: LongToDoubleFunction, mappedStorage: array<double>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: LongStream, mapper: LongFunction): LongStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here
        // #UtBot note: as mapper can produce infinite streams, we cannot process it symbolically. This is temporary decision.
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.sorted (@target self: LongStream): LongStream
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = new LongStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
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

            result = new LongStreamAutomaton(state = Initialized,
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
        _checkConsumed();

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
            val visited: map<Long, Object> = action MAP_NEW();
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

        _consume();
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<long>, visited: map<Long, Long>, j: int, uniqueItems: list<Long>): void
    {
        val item: long = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, SOMETHING);
            action LIST_INSERT_AT(uniqueItems, j, item);
            j += 1;
        }
    }

    @Phantom proc distinct_loopRecoverItems (i: int, uniqueItems: list<Long>, distinctStorage: array<long>): void
    {
        val item: Long = action LIST_GET(uniqueItems, i);
        action ASSUME(item != null);
        distinctStorage[i] = item as long;
    }


    fun *.peek (@target self: Stream, _action: LongConsumer): LongStream
    {
        _checkConsumed();

        _actionApply(_action);

        result = new LongStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    fun *.limit (@target self: LongStream, maxSize: long): LongStream
    {
        val maxSizeInt: int = maxSize as int;

        _checkConsumed();

        if (maxSizeInt < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSizeInt == 0)
        {
            result = new LongStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSizeInt > this.length)
        {
            result = new LongStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            val limitStorage: array<long> = action ARRAY_NEW("long", maxSizeInt);

            action ARRAY_COPY(this.storage, 0, limitStorage, 0, maxSizeInt);

            result = new LongStreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
                closeHandlers = this.closeHandlers,
            );
        }

        _consume();
    }


    fun *.skip (@target self: LongStream, n: long): LongStream
    {
        val offset: int = n as int;

        _checkConsumed();

        if (offset < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (offset == 0)
        {
            result = new LongStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (offset >= this.length)
        {
            var newArray: array<long> = [];
            result = new LongStreamAutomaton(state = Initialized,
                storage = newArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
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

        _consume();
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<long>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }


    fun *.forEach (@target self: LongStream, _action: LongConsumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.forEachOrdered (@target self: LongStream, _action: LongConsumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.toArray (@target self: LongStream): array<long>
    {
        _checkConsumed();

        result = this.storage;
        _consume();
    }


    fun *.reduce (@target self: LongStream, identity: long, accumulator: LongBinaryOperator): long
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


    @Phantom proc _accumulate_loop (i: int, accumulator: LongBinaryOperator, result: long): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.reduce (@target self: LongStream, accumulator: LongBinaryOperator): OptionalLong
    {
        _checkConsumed();

        if (accumulator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalLong.empty()");
        }
        else if (this.length > 0)
        {
            var value: long = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _accumulate_optional_loop(i, accumulator, value)
            );

            result = action DEBUG_DO("OptionalLong.of(value)");
        }

        _consume();
    }


    @Phantom proc _accumulate_optional_loop (i: int, accumulator: LongBinaryOperator, value: long): void
    {
        value = action CALL(accumulator, [value, this.storage[i]]);
    }


    fun *.collect (@target self: LongStream, supplier: Supplier, accumulator: ObjLongConsumer, combiner: BiConsumer): Object
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


    @Phantom proc _accumulate_with_biConsumer_loop (i: int, accumulator: ObjLongConsumer, result: Object): void
    {
        action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.min (@target self: LongStream): OptionalLong
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalLong.empty()");
        }
        else
        {
            var min: long = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_min_loop(i, min)
            );

            result = action DEBUG_DO("OptionalLong.of(min)");
        }

        _consume();
    }


    @Phantom proc _find_min_loop (i: int, min: long): void
    {
        if (min > this.storage[i])
            min = this.storage[i];
    }


    fun *.max (@target self: IntStream): OptionalLong
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalLong.empty()");
        }
        else
        {
            var max: long = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_max_loop(i, max)
            );

            result = action DEBUG_DO("OptionalLong.of(max)");
        }

        _consume();
    }


    @Phantom proc _find_max_loop (i: int, max: long): void
    {
        if (max < this.storage[i])
            max = this.storage[i];
    }


    fun *.count (@target self: LongStream): long
    {
        _checkConsumed();

        result = this.length;
        _consume();
    }


    fun *.anyMatch (@target self: LongStream, predicate: LongPredicate): boolean
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


    fun *.allMatch (@target self: LongStream, predicate: LongPredicate): boolean
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        result = true;

        if (this.length > 0)
        {
            result = false
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


    fun *.noneMatch (@target self: LongStream, predicate: LongPredicate): boolean
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        result = true;

        if (this.length > 0)
        {
            result = false
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


    fun *.findFirst (@target self: LongStream): OptionalLong
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.findAny (@target self: LongStream): OptionalLong
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.iterator (@target self: LongStream): PrimitiveIterator_OfLong
    {
        _checkConsumed();

        result = new LongStreamIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
        );

        _consume();
    }


    // #todo: must be created spliterator realization
    fun *.spliterator (@target self: LongStream): Spliterator_OfLong
    {
        _checkConsumed();

        result = action SYMBOLIC("java.util.Spliterator.OfLong");
        action ASSUME(result != null);

        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.isParallel (@target self: LongStream): boolean
    {
        result = this.isParallel;
    }


    fun *.sequential (@target self: LongStream): LongStream
    {
        this.isParallel = false;
        result = self;
    }


    fun *.parallel (@target self: LongStream): LongStream
    {
        this.isParallel = true;
        result = self;
    }


    fun *.unordered (@target self: LongStream): LongStream
    {
        _checkConsumed();
        result = self;
        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: LongStream, closeHandler: Runnable): LongStream
    {
        // #todo: make chain of the runnable's like in the original method (java.util.stream.AbstractPipeline#onClose)
        _checkConsumed();

        val listLength: int = action LIST_SIZE(this.closeHandlers);
        action LIST_INSERT_AT(this.closeHandlers, listLength, closeHandler);
        result = self;
    }


    // within java.lang.AutoCloseable
    fun *.close (@target self: LongStream): void
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


    fun *.dropWhile (@target self: LongStream, predicate: LongPredicate): LongStream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<long> = action ARRAY_NEW("long", 0);
            result = new LongStreamAutomaton(state = Initialized,
                storage = emptyStorage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            action ASSUME(this.length > 0);

            var dropLength: int = 0;

            var i: int = 0;
            action LOOP_WHILE(
                i < this.length && action CALL(predicate, [this.storage[i]]),
                _dropWhile_loop(i, dropLength, predicate)
            );

            if (dropLength == 0)
            {
                result = new LongStreamAutomaton(state = Initialized,
                    storage = this.storage,
                    length = this.length,
                    closeHandlers = this.closeHandlers,
                );
            }
            else
            {
                val newLength: int = this.length - dropLength;
                val newStorage: array<long> = action ARRAY_NEW("long", newLength);

                var j: int = dropLength;
                i = dropLength;
                action LOOP_WHILE(
                    i < this.length,
                    _copy_dropWhile_loop(i, j, newStorage)
                );

                result = new LongStreamAutomaton(state = Initialized,
                    storage = newStorage,
                    length = newLength,
                    closeHandlers = this.closeHandlers,
                );
            }
        }

        _consume();
    }


    @Phantom proc _dropWhile_loop (i: int, dropLength: int, predicate: DoublePredicate): void
    {
        dropLength += 1;
        i += 1;
    }


    @Phantom proc _copy_dropWhile_loop (i: int, j: int, newStorage: array<long>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
        i += 1;
    }


    fun *.takeWhile (@target self: LongStream, predicate: LongPredicate): LongStream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<long> = action ARRAY_NEW("long", 0);
            result = new LongStreamAutomaton(state = Initialized,
                storage = emptyStorage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            action ASSUME(this.length > 0);

            var takeLength: int = 0;

            var i: int = 0;
            action LOOP_WHILE(
                i < this.length && action CALL(predicate, [this.storage[i]]),
                _takeWhile_loop(i, takeLength, predicate)
            );

            if (takeLength == this.length)
            {
                result = new LongStreamAutomaton(state = Initialized,
                    storage = this.storage,
                    length = this.length,
                    closeHandlers = this.closeHandlers,
                );
            }
            else
            {
                val newLength: int = takeLength;
                val newStorage: array<long> = action ARRAY_NEW("long", newLength);

                var j: int = 0;
                i = 0;
                action LOOP_WHILE(
                    i < takeLength,
                    _copy_takeWhile_loop(i, j, newStorage)
                );

                result = new LongStreamAutomaton(state = Initialized,
                    storage = newStorage,
                    length = newLength,
                    closeHandlers = this.closeHandlers,
                );
            }
        }

        _consume();
    }


    @Phantom proc _takeWhile_loop (i: int, takeLength: int, predicate: DoublePredicate): void
    {
        takeLength += 1;
        i += 1;
    }


    @Phantom proc _copy_takeWhile_loop (i: int, j: int, newStorage: array<long>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
        i += 1;
    }


    fun *.asDoubleStream (@target self: LongStream): DoubleStream
    {
        if (this.length == 0)
        {
            val emptyArray: array<double> = action ARRAY_NEW("double", 0);
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = emptyArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            action ASSUME(this.length > 0);

            val newStorage: array<double> = action ARRAY_NEW("double", this.length);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _convertLongStorageToDouble_loop(i, newStorage)
            );

            result = new DoubleStreamAutomaton(state = Initialized,
                storage = newStorage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
    }


    @Phantom proc _convertLongStorageToDouble_loop(i: int, newStorage: array<double>): void
    {
        newStorage[i] = this.storage[i] as int;
    }


    fun *.sum (@target self: LongStream): long
    {
        _checkConsumed();

        result = _sum();

        _consume();
    }


    fun *.average (@target self: LongStream): OptionalDouble
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalDouble.empty()");
        }
        else
        {
            var curSum: double = _sum();
            var divisionResult: double = curSum / this.length;
            result = action DEBUG_DO("OptionalDouble.of(divisionResult)");
        }

        _consume();
    }


    fun *.summaryStatistics (@target self: LongStream): LongSummaryStatistics
    {
        _checkConsumed();

        result = action DEBUG_DO("new LongSummaryStatistics()");
        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _getStatistics_loop(i, result)
        );

        _consume();
    }


    @Phantom proc _getStatistics_loop (i: int, result: LongSummaryStatistics): void
    {
        action CALL_METHOD(result, "accept", [this.storage[i]]);
    }


    fun *.boxed (@target self: LongStream): Stream
    {
        _checkConsumed();

        val longArray: array<Long> = action ARRAY_NEW("java.lang.Long", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _boxToLong_loop(i, longArray)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = longArray,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    @Phantom proc _boxToLong_loop (i: int, longArray: array<Long>): void
    {
        longArray[i] = this.storage[i];
    }
}