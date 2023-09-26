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
        flatMap,
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


    fun *.flatMap(@target self: Stream, mapper: Function): Stream
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