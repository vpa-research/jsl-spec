libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtIntStream.java";

// imports

import java/util/stream/IntStream;
import java/lang/Integer;
import java/util/function/IntPredicate;
import java/util/function/IntUnaryOperator;
import java/util/function/IntToLongFunction;
import java/util/function/IntToDoubleFunction;
import java/util/function/IntBinaryOperator;
import java/util/function/ObjIntConsumer;
import java/util/IntSummaryStatistics;
import java/util/PrimitiveIterator;
import java/util/OptionalDouble;
import java/util/OptionalInt;


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

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        allMatch,
        anyMatch,
        asDoubleStream,
        asLongStream,
        average,
        boxed,
        close,
        collect,
        count,
        distinct,
        dropWhile,
        filter,
        findAny,
        findFirst,
        flatMap,
        forEach,
        forEachOrdered,
        isParallel,
        iterator,
        limit,
        map,
        mapToDouble,
        mapToLong,
        mapToObj,
        max,
        min,
        noneMatch,
        onClose,
        parallel,
        peek,
        reduce (IntStream, IntBinaryOperator),
        reduce (IntStream, int, IntBinaryOperator),
        sequential,
        skip,
        sorted,
        spliterator,
        sum,
        summaryStatistics,
        takeWhile,
        toArray,
        unordered,
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
            result = action CALL_METHOD(null as OptionalInt, "empty", []);
        }
        else
        {
            val first: int = this.storage[0];
            result = action CALL_METHOD(null as OptionalInt, "of", [first]);
        }
    }


    proc _sum (): int
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

    // methods

    fun *.filter (@target self: IntStream, predicate: IntPredicate): IntStream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        var filteredStorage: array<int> = action ARRAY_NEW("int", this.length);
        var filteredLength: int = 0;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _filter_loop(i, predicate, filteredLength, filteredStorage)
        );

        action ASSUME(filteredLength <= this.length);

        var resultStorage: array<int> = action ARRAY_NEW("int", filteredLength);
        action ARRAY_COPY(filteredStorage, 0, resultStorage, 0, filteredLength);

        result = new IntStreamAutomaton(state = Initialized,
            storage = resultStorage,
            length = filteredLength,
            closeHandlers = this.closeHandlers,
        );

        _consume();
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
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapped_loop (i: int, mapper: IntUnaryOperator, mappedStorage: array<int>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToObj (@target self: IntStream, mapper: IntFunction): Stream
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


    @Phantom proc _mapToObj_loop (i: int, objStorage: array<Object>, mapper: IntFunction): void
    {
        objStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToLong (@target self: IntStream, mapper: IntToLongFunction): LongStream
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


    @Phantom proc _mapToLong_loop (i: int, mapper: IntToLongFunction, mappedStorage: array<long>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToDouble (@target self: IntStream, mapper: IntToDoubleFunction): DoubleStream
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


    @Phantom proc _mapToDouble_loop (i: int, mapper: IntToDoubleFunction, mappedStorage: array<double>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: IntStream, mapper: IntFunction): IntStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here
        // #UtBot note: as mapper can produce infinite streams, we cannot process it symbolically. This is temporary decision.
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.sorted (@target self: IntStream): IntStream
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = new IntStreamAutomaton(state = Initialized,
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

            result = new IntStreamAutomaton(state = Initialized,
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
        _checkConsumed();

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
            val visited: map<Integer, Object> = action MAP_NEW();
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

        _consume();
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<int>, visited: map<Integer, Object>, j: int, uniqueItems: list<Integer>): void
    {
        val item: int = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, SOMETHING);
            action LIST_INSERT_AT(uniqueItems, j, item);
            j += 1;
        }
    }

    @Phantom proc distinct_loopRecoverItems (i: int, uniqueItems: list<Integer>, distinctStorage: array<int>): void
    {
        val item: Integer = action LIST_GET(uniqueItems, i);
        action ASSUME(item != null);
        distinctStorage[i] = item as int;
    }


    fun *.peek (@target self: IntStream, _action: IntConsumer): IntStream
    {
        _checkConsumed();

        _actionApply(_action);

        result = new IntStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    fun *.limit (@target self: IntStream, maxSize: long): IntStream
    {
        val maxSizeInt: int = maxSize as int;

        _checkConsumed();

        if (maxSizeInt < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSizeInt == 0)
        {
            result = new IntStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSizeInt > this.length)
        {
            result = new IntStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            val limitStorage: array<int> = action ARRAY_NEW("int", maxSizeInt);

            action ARRAY_COPY(this.storage, 0, limitStorage, 0, maxSizeInt);

            result = new IntStreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
                closeHandlers = this.closeHandlers,
            );
        }

        _consume();
    }


    fun *.skip (@target self: IntStream, n: long): IntStream
    {
        val offset: int = n as int;

        _checkConsumed();

        if (offset < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (offset == 0)
        {
            result = new IntStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (offset >= this.length)
        {
            var newArray: array<int> = [];
            result = new IntStreamAutomaton(state = Initialized,
                storage = newArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
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

        _consume();
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<int>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }

    fun *.forEach (@target self: IntStream, _action: IntConsumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.forEachOrdered (@target self: IntStream, _action: IntConsumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.toArray (@target self: IntStream): array<int>
    {
        _checkConsumed();

        result = this.storage;
        _consume();
    }


    fun *.reduce (@target self: IntStream, identity: int, accumulator: IntBinaryOperator): int
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


    @Phantom proc _accumulate_loop (i: int, accumulator: IntBinaryOperator, result: int): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.reduce (@target self: IntStream, accumulator: IntBinaryOperator): OptionalInt
    {
        _checkConsumed();

        if (accumulator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as OptionalInt, "empty", []);
        }
        else if (this.length > 0)
        {
            var value: int = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _accumulate_optional_loop(i, accumulator, value)
            );

            result = action CALL_METHOD(null as OptionalInt, "of", [value]);
        }

        _consume();
    }


    @Phantom proc _accumulate_optional_loop (i: int, accumulator: IntBinaryOperator, value: int): void
    {
        value = action CALL(accumulator, [value, this.storage[i]]);
    }


    fun *.collect (@target self: IntStream, supplier: Supplier, accumulator: ObjIntConsumer, combiner: BiConsumer): Object
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


    @Phantom proc _accumulate_with_biConsumer_loop (i: int, accumulator: ObjIntConsumer, result: Object): void
    {
        action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.min (@target self: IntStream): OptionalInt
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as OptionalInt, "empty", []);
        }
        else
        {
            var min: int = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_min_loop(i, min)
            );

            result = action CALL_METHOD(null as OptionalInt, "of", [min]);
        }

        _consume();
    }


    @Phantom proc _find_min_loop (i: int, min: int): void
    {
        if (min > this.storage[i])
            min = this.storage[i];
    }


    fun *.max (@target self: IntStream): OptionalInt
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as OptionalInt, "empty", []);
        }
        else
        {
            var max: int = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_max_loop(i, max)
            );

            result = action CALL_METHOD(null as OptionalInt, "of", [max]);
        }

        _consume();
    }


    @Phantom proc _find_max_loop (i: int, max: int): void
    {
        if (max < this.storage[i])
            max = this.storage[i];
    }


    fun *.count (@target self: IntStream): long
    {
        _checkConsumed();

        result = this.length;
        _consume();
    }


    fun *.anyMatch (@target self: IntStream, predicate: IntPredicate): boolean
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


    fun *.allMatch (@target self: IntStream, predicate: IntPredicate): boolean
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


    fun *.noneMatch (@target self: IntStream, predicate: IntPredicate): boolean
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


    fun *.findFirst (@target self: IntStream): OptionalInt
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.findAny (@target self: IntStream): OptionalInt
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.iterator (@target self: IntStream): PrimitiveIterator_OfInt
    {
        _checkConsumed();

        result = new IntStreamIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
        );

        _consume();
    }


    // #question: This is right realization of the spliterator ? Or not ? And this is right characteristics ?
    fun *.spliterator (@target self: IntStream): Spliterator_OfInt
    {
        _checkConsumed();

        result = new Spliterators_IntArraySpliteratorAutomaton(state = Initialized,
            array = this.storage,
            index = 0,
            fence = this.length,
            characteristics = SPLITERATOR_ORDERED | SPLITERATOR_IMMUTABLE | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED,
        );

        _consume();
    }


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
        _checkConsumed();
        result = new IntStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );
        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: IntStream, closeHandler: Runnable): IntStream
    {
        // #todo: make chain of the runnable's like in the original method (java.util.stream.AbstractPipeline#onClose)
        _checkConsumed();

        val listLength: int = action LIST_SIZE(this.closeHandlers);
        action LIST_INSERT_AT(this.closeHandlers, listLength, closeHandler);
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

        _consume();
    }


    @Phantom proc _closeHandlers_loop (i: int): void
    {
        val currentHandler: Runnable = action LIST_GET(this.closeHandlers, i) as Runnable;
        action CALL(currentHandler, []);
    }


    fun *.dropWhile (@target self: IntStream, predicate: IntPredicate): IntStream
    {
        _checkConsumed();

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
            action ASSUME(this.length > 0);

            var dropLength: int = 0;

            var i: int = 0;
            action LOOP_WHILE(
                i < this.length && action CALL(predicate, [this.storage[i]]),
                _dropWhile_loop(i, dropLength)
            );

            if (dropLength == 0)
            {
                result = new IntStreamAutomaton(state = Initialized,
                    storage = this.storage,
                    length = this.length,
                    closeHandlers = this.closeHandlers,
                );
            }
            else
            {
                val newLength: int = this.length - dropLength;
                val newStorage: array<int> = action ARRAY_NEW("int", newLength);

                var j: int = dropLength;
                i = dropLength;
                action LOOP_WHILE(
                    i < this.length,
                    _copy_dropWhile_loop(i, j, newStorage)
                );

                result = new IntStreamAutomaton(state = Initialized,
                    storage = newStorage,
                    length = newLength,
                    closeHandlers = this.closeHandlers,
                );
            }
        }

        _consume();
    }


    @Phantom proc _dropWhile_loop (i: int, dropLength: int): void
    {
        dropLength += 1;
        i += 1;
    }


    @Phantom proc _copy_dropWhile_loop (i: int, j: int, newStorage: array<int>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
        i += 1;
    }


    fun *.takeWhile (@target self: IntStream, predicate: IntPredicate): IntStream
    {
        _checkConsumed();

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
            action ASSUME(this.length > 0);

            var takeLength: int = 0;

            var i: int = 0;
            action LOOP_WHILE(
                i < this.length && action CALL(predicate, [this.storage[i]]),
                _takeWhile_loop(i, takeLength)
            );

            if (takeLength == this.length)
            {
                result = new IntStreamAutomaton(state = Initialized,
                    storage = this.storage,
                    length = this.length,
                    closeHandlers = this.closeHandlers,
                );
            }
            else
            {
                val newLength: int = takeLength;
                val newStorage: array<int> = action ARRAY_NEW("int", newLength);

                var j: int = 0;
                i = 0;
                action LOOP_WHILE(
                    i < takeLength,
                    _copy_takeWhile_loop(i, j, newStorage)
                );

                result = new IntStreamAutomaton(state = Initialized,
                    storage = newStorage,
                    length = newLength,
                    closeHandlers = this.closeHandlers,
                );
            }
        }

        _consume();
    }


    @Phantom proc _takeWhile_loop (i: int, takeLength: int): void
    {
        takeLength += 1;
        i += 1;
    }


    @Phantom proc _copy_takeWhile_loop (i: int, j: int, newStorage: array<int>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
        i += 1;
    }


    fun *.asLongStream (@target self: IntStream): LongStream
    {
        _checkConsumed();

        if (this.length == 0)
        {
            val emptyArray: array<long> = [];
            result = new LongStreamAutomaton(state = Initialized,
                storage = emptyArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            action ASSUME(this.length > 0);

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

        _consume();
    }


    @Phantom proc _convertIntStorageToLong_loop(i: int, newStorage: array<long>): void
    {
        newStorage[i] = this.storage[i] as long;
    }


    fun *.asDoubleStream (@target self: IntStream): DoubleStream
    {
        _checkConsumed();

        if (this.length == 0)
        {
            val emptyArray: array<double> = [];
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
                _convertIntStorageToDouble_loop(i, newStorage)
            );

            result = new DoubleStreamAutomaton(state = Initialized,
                storage = newStorage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }

        _consume();
    }


    @Phantom proc _convertIntStorageToDouble_loop(i: int, newStorage: array<double>): void
    {
        newStorage[i] = this.storage[i] as double;
    }


    fun *.sum (@target self: IntStream): int
    {
        _checkConsumed();

        result = _sum();

        _consume();
    }


    fun *.average (@target self: IntStream): OptionalDouble
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action CALL_METHOD(null as OptionalDouble, "empty", []);
        }
        else
        {
            var curSum: double = _sum();
            var divisionResult: double = curSum / this.length;
            result = action CALL_METHOD(null as OptionalDouble, "of", [divisionResult]);
        }

        _consume();
    }


    fun *.summaryStatistics (@target self: IntStream): IntSummaryStatistics
    {
        _checkConsumed();

        result = action DEBUG_DO("new IntSummaryStatistics()");
        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _getStatistics_loop(i, result)
        );

        _consume();
    }


    @Phantom proc _getStatistics_loop (i: int, result: IntSummaryStatistics): void
    {
        action CALL_METHOD(result, "accept", [this.storage[i]]);
    }


    fun *.boxed (@target self: IntStream): Stream
    {
        _checkConsumed();

        val integerArray: array<Integer> = action ARRAY_NEW("java.lang.Integer", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _boxToInteger_loop(i, integerArray)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = integerArray,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    @Phantom proc _boxToInteger_loop (i: int, integerArray: array<Integer>): void
    {
        integerArray[i] = this.storage[i];
    }
}