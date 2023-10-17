libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/stream/UtDoubleStream.java";

// imports

import java/util/stream/DoubleStream;
import java/lang/Double;
import java/util/function/DoubleFunction;
import java/util/function/DoublePredicate;
import java/util/function/DoubleUnaryOperator;
import java/util/function/DoubleToLongFunction;
import java/util/function/DoubleToIntFunction;
import java/util/function/DoubleBinaryOperator;
import java/util/function/ObjDoubleConsumer;
import java/util/DoubleSummaryStatistics;
import java/util/PrimitiveIterator;


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

    initstate Initialized;

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
        forEach,
        forEachOrdered,
        toArray,
        reduce (DoubleStream, double, DoubleBinaryOperator),
        reduce (DoubleStream, DoubleBinaryOperator),
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


    proc _findFirst (): OptionalDouble
    {
        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalDouble.empty()");
        }
        else
        {
            val first: double = this.storage[0];
            result = action DEBUG_DO("OptionalDouble.of(first)");
        }
    }


    proc _sum (): double
    {
        result = 0;

        if (this.length != 0)
        {
            var anyNaN: boolean = false;
            var anyPositiveInfinity: boolean = false;
            var anyNegativeInfinity: boolean = false;

            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _sum_loop(i, result, anyNaN, anyPositiveInfinity, anyNegativeInfinity)
            );

            if (anyNaN)
                result = DOUBLE_NAN;
            else if (anyPositiveInfinity && anyNegativeInfinity)
                result = DOUBLE_NAN;
            else if (anyPositiveInfinity && result == DOUBLE_NEGATIVE_INFINITY)
                result = DOUBLE_NAN;
            else if (anyNegativeInfinity && result == DOUBLE_POSITIVE_INFINITY)
                result = DOUBLE_NAN;
        }

    }


    @Phantom proc _sum_loop (i: int, result: double, anyNaN: boolean, anyPositiveInfinity: boolean, anyNegativeInfinity: boolean): void
    {
        val element: double = this.storage[i];
        result += element;

        if (action DEBUG_DO("Double.isNaN(element)"))
            anyNaN = true;

        if (element == DOUBLE_POSITIVE_INFINITY)
            anyPositiveInfinity = true;

        if (element == DOUBLE_NEGATIVE_INFINITY)
            anyNegativeInfinity = true;
    }


    // methods

    fun *.filter (@target self: DoubleStream, predicate: DoublePredicate): DoubleStream
    {
        _checkConsumed();

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

        _consume();
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
        _checkConsumed();

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

        _consume();
    }


    @Phantom proc _mapped_loop (i: int, mapper: DoubleUnaryOperator, mappedStorage: array<double>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToObj (@target self: DoubleStream, mapper: DoubleFunction): Stream
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


    @Phantom proc _mapToObj_loop (i: int, objStorage: array<Object>, mapper: DoubleFunction): void
    {
        objStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToLong (@target self: DoubleStream, mapper: DoubleToLongFunction): LongStream
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


    @Phantom proc _mapToLong_loop (i: int, mapper: DoubleToLongFunction, mappedStorage: array<long>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.mapToInt (@target self: DoubleStream, mapper: DoubleToIntFunction): IntStream
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


    @Phantom proc _mapToInt_loop (i: int, mapper: DoubleToIntFunction, mappedStorage: array<int>): void
    {
        mappedStorage[i] = action CALL(mapper, [this.storage[i]]);
    }


    fun *.flatMap (@target self: DoubleStream, mapper: DoubleFunction): DoubleStream
    {
        _checkConsumed();

        if (mapper == null)
            _throwNPE();

        // #todo: call mapper here
        // #UtBot note: as mapper can produce infinite streams, we cannot process it symbolically. This is temporary decision.
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);

        _consume();
    }


    fun *.sorted (@target self: DoubleStream): DoubleStream
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
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

            result = new DoubleStreamAutomaton(state = Initialized,
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
        _checkConsumed();

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
            val visited: map<Double, Object> = action MAP_NEW();
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

        _consume();
    }

    @Phantom proc distinct_loopStoreItems (i: int, items: array<double>, visited: map<Double, Double>, j: int, uniqueItems: list<Double>): void
    {
        val item: double = items[i];
        if (action MAP_HAS_KEY(visited, item) == false)
        {
            action MAP_SET(visited, item, SOMETHING);
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
        _checkConsumed();

        _actionApply(_action);

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = this.storage,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    fun *.limit (@target self: DoubleStream, maxSize: long): DoubleStream
    {
        val maxSizeInt: int = maxSize as int;

        _checkConsumed();

        if (maxSizeInt < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (maxSizeInt == 0)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (maxSizeInt > this.length)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
            val limitStorage: array<double> = action ARRAY_NEW("double", maxSizeInt);

            action ARRAY_COPY(this.storage, 0, limitStorage, 0, maxSizeInt);

            result = new DoubleStreamAutomaton(state = Initialized,
                storage = limitStorage,
                length = maxSizeInt,
                closeHandlers = this.closeHandlers,
            );
        }

        _consume();
    }


    fun *.skip (@target self: DoubleStream, n: long): DoubleStream
    {
        val offset: int = n as int;

        _checkConsumed();

        if (offset < 0)
            action THROW_NEW("java.lang.IllegalArgumentException", []);

        if (offset == 0)
        {
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = this.storage,
                length = this.length,
                closeHandlers = this.closeHandlers,
            );
        }
        else if (offset >= this.length)
        {
            var newArray: array<double> = [];
            result = new DoubleStreamAutomaton(state = Initialized,
                storage = newArray,
                length = 0,
                closeHandlers = this.closeHandlers,
            );
        }
        else
        {
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

        _consume();
    }


    @Phantom proc _skip_loop (i: int, skipIndex: int, skipStorage: array<double>): void
    {
        skipStorage[skipIndex] = this.storage[i];
        skipIndex += 1;
    }


    fun *.forEach (@target self: DoubleStream, _action: DoubleConsumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.forEachOrdered (@target self: DoubleStream, _action: DoubleConsumer): void
    {
        _checkConsumed();

        _actionApply(_action);
        _consume();
    }


    fun *.toArray (@target self: DoubleStream): array<double>
    {
        _checkConsumed();

        result = this.storage;
        _consume();
    }


    fun *.reduce (@target self: DoubleStream, identity: double, accumulator: DoubleBinaryOperator): double
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


    @Phantom proc _accumulate_loop (i: int, accumulator: DoubleBinaryOperator, result: double): void
    {
        result = action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.reduce (@target self: DoubleStream, accumulator: DoubleBinaryOperator): OptionalDouble
    {
        _checkConsumed();

        if (accumulator == null)
            _throwNPE();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalDouble.empty()");
        }
        else if (this.length > 0)
        {
            var value: double = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _accumulate_optional_loop(i, accumulator, value)
            );

            result = action DEBUG_DO("OptionalDouble.of(value)");
        }

        _consume();
    }


    @Phantom proc _accumulate_optional_loop (i: int, accumulator: DoubleBinaryOperator, value: double): void
    {
        value = action CALL(accumulator, [value, this.storage[i]]);
    }


    fun *.collect (@target self: DoubleStream, supplier: Supplier, accumulator: ObjDoubleConsumer, combiner: BiConsumer): Object
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


    @Phantom proc _accumulate_with_biConsumer_loop (i: int, accumulator: ObjDoubleConsumer, result: Object): void
    {
        action CALL(accumulator, [result, this.storage[i]]);
    }


    fun *.min (@target self: DoubleStream): OptionalDouble
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalDouble.empty()");
        }
        else
        {
            var min: double = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_min_loop(i, min)
            );

            result = action DEBUG_DO("OptionalDouble.of(min)");
        }

        _consume();
    }


    @Phantom proc _find_min_loop (i: int, min: double): void
    {
        if (min > this.storage[i])
            min = this.storage[i];
    }


    fun *.max (@target self: DoubleStream): OptionalDouble
    {
        _checkConsumed();

        if (this.length == 0)
        {
            result = action DEBUG_DO("OptionalDouble.empty()");
        }
        else
        {
            var max: double = this.storage[0];

            var i: int = 0;
            action LOOP_FOR(
                i, 1, this.length, +1,
                _find_max_loop(i, max)
            );

            result = action DEBUG_DO("OptionalDouble.of(max)");
        }

        _consume();
    }


    @Phantom proc _find_max_loop (i: int, max: double): void
    {
        if (max < this.storage[i])
            max = this.storage[i];
    }


    fun *.count (@target self: DoubleStream): long
    {
        _checkConsumed();

        result = this.length;
        _consume();
    }


    fun *.anyMatch (@target self: DoubleStream, predicate: DoublePredicate): boolean
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


    fun *.allMatch (@target self: DoubleStream, predicate: DoublePredicate): boolean
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


    fun *.noneMatch (@target self: DoubleStream, predicate: DoublePredicate): boolean
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


    fun *.findFirst (@target self: DoubleStream): OptionalDouble
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.findAny (@target self: DoubleStream): OptionalDouble
    {
        _checkConsumed();

        result = _findFirst();
        _consume();
    }


    fun *.iterator (@target self: DoubleStream): PrimitiveIterator_OfDouble
    {
        _checkConsumed();

        result = new DoubleStreamIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
        );

        _consume();
    }


    // #todo: must be created spliterator realization
    fun *.spliterator (@target self: DoubleStream): Spliterator_OfDouble
    {
        _checkConsumed();

        result = action SYMBOLIC("java.util.Spliterator.OfDouble");
        action ASSUME(result != null);

        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.isParallel (@target self: DoubleStream): boolean
    {
        result = this.isParallel;
    }


    fun *.sequential (@target self: DoubleStream): DoubleStream
    {
        this.isParallel = false;
        result = self;
    }


    fun *.parallel (@target self: DoubleStream): DoubleStream
    {
        this.isParallel = true;
        result = self;
    }


    fun *.unordered (@target self: DoubleStream): DoubleStream
    {
        _checkConsumed();
        result = self;
        _consume();
    }


    // within java.util.stream.BaseStream
    fun *.onClose (@target self: DoubleStream, closeHandler: Runnable): DoubleStream
    {
        _checkConsumed();

        val listLength: int = action LIST_SIZE(this.closeHandlers);
        action LIST_INSERT_AT(this.closeHandlers, listLength, closeHandler);
        result = self;
    }


    // within java.lang.AutoCloseable
    fun *.close (@target self: DoubleStream): void
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


    fun *.dropWhile (@target self: DoubleStream, predicate: DoublePredicate): DoubleStream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<double> = action ARRAY_NEW("double", 0);
            result = new DoubleStreamAutomaton(state = Initialized,
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


    @Phantom proc _dropWhile_loop (i: int, dropLength: int, predicate: DoublePredicate): void
    {
        dropLength += 1;
        i += 1;
    }


    @Phantom proc _copy_dropWhile_loop (i: int, j: int, newStorage: array<double>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
        i += 1;
    }


    fun *.takeWhile (@target self: DoubleStream, predicate: DoublePredicate): DoubleStream
    {
        _checkConsumed();

        if (predicate == null)
            _throwNPE();

        if (this.length == 0)
        {
            val emptyStorage: array<double> = action ARRAY_NEW("double", 0);
            result = new DoubleStreamAutomaton(state = Initialized,
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
                result = new DoubleStreamAutomaton(state = Initialized,
                    storage = this.storage,
                    length = this.length,
                    closeHandlers = this.closeHandlers,
                );
            }
            else
            {
                val newLength: int = takeLength;
                val newStorage: array<double> = action ARRAY_NEW("double", newLength);

                var j: int = 0;
                i = 0;
                action LOOP_WHILE(
                    i < takeLength,
                    _copy_takeWhile_loop(i, j, newStorage)
                );

                result = new DoubleStreamAutomaton(state = Initialized,
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


    @Phantom proc _copy_takeWhile_loop (i: int, j: int, newStorage: array<double>): void
    {
        newStorage[j] = this.storage[i];
        j += 1;
        i += 1;
    }


    fun *.sum (@target self: DoubleStream): double
    {
        _checkConsumed();

        result = _sum();

        _consume();
    }


    fun *.average (@target self: DoubleStream): OptionalDouble
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


    fun *.summaryStatistics (@target self: DoubleStream): DoubleSummaryStatistics
    {
        _checkConsumed();

        // #problem I'm waiting DoubleSummaryStatistics type in separated files
        action TODO();
    }


    fun *.boxed (@target self: DoubleStream): Stream
    {
        _checkConsumed();

        val doubleArray: array<Double> = action ARRAY_NEW("java.lang.Double", this.length);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _boxToDouble_loop(i, doubleArray)
        );

        result = new StreamAutomaton(state = Initialized,
            storage = doubleArray,
            length = this.length,
            closeHandlers = this.closeHandlers,
        );

        _consume();
    }


    @Phantom proc _boxToDouble_loop (i: int, doubleArray: array<Double>): void
    {
        doubleArray[i] = this.storage[i];
    }
}