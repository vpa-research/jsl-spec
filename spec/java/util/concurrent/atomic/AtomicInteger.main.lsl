libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicInteger.java";

// imports

import java/lang/String;
import java/util/function/IntBinaryOperator;
import java/util/function/IntUnaryOperator;

import java/util/concurrent/atomic/AtomicInteger;


// automata

automaton AtomicIntegerAutomaton
(
    @private @volatile var value: int = 0, // WARNING: do not rename!
)
: LSLAtomicInteger
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (LSLAtomicInteger),
        `<init>` (LSLAtomicInteger, int),
    ];

    shift Initialized -> self by [
        // instance methods
        accumulateAndGet,
        addAndGet,
        byteValue,
        compareAndExchange,
        compareAndExchangeAcquire,
        compareAndExchangeRelease,
        compareAndSet,
        decrementAndGet,
        doubleValue,
        floatValue,
        get,
        getAcquire,
        getAndAccumulate,
        getAndAdd,
        getAndDecrement,
        getAndIncrement,
        getAndSet,
        getAndUpdate,
        getOpaque,
        getPlain,
        incrementAndGet,
        intValue,
        lazySet,
        longValue,
        set,
        setOpaque,
        setPlain,
        setRelease,
        shortValue,
        toString,
        updateAndGet,
        weakCompareAndSet,
        weakCompareAndSetAcquire,
        weakCompareAndSetPlain,
        weakCompareAndSetRelease,
        weakCompareAndSetVolatile,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: LSLAtomicInteger)
    {
        this.value = 0;
    }


    constructor *.`<init>` (@target self: LSLAtomicInteger, initialValue: int)
    {
        this.value = initialValue;
    }


    // static methods

    // methods

    @final fun *.accumulateAndGet (@target self: LSLAtomicInteger, x: int, accumulatorFunction: IntBinaryOperator): int
    {
        result = action CALL(accumulatorFunction, [this.value, x]);
        this.value = result;
    }


    @final fun *.addAndGet (@target self: LSLAtomicInteger, delta: int): int
    {
        result = this.value + delta;
        this.value = result;
    }


    // within java.lang.Number
    fun *.byteValue (@target self: LSLAtomicInteger): byte
    {
        result = this.value as byte;
    }


    @final fun *.compareAndExchange (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): int
    {
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndExchangeAcquire (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): int
    {
        // #problem: unable to model memory side-effects
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndExchangeRelease (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): int
    {
        // #problem: unable to model memory side-effects
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndSet (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): boolean
    {
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.decrementAndGet (@target self: LSLAtomicInteger): int
    {
        result = this.value - 1;
        this.value = result;
    }


    fun *.doubleValue (@target self: LSLAtomicInteger): double
    {
        result = this.value as double;
    }


    fun *.floatValue (@target self: LSLAtomicInteger): float
    {
        result = this.value as float;
    }


    @final fun *.get (@target self: LSLAtomicInteger): int
    {
        result = this.value;
    }


    @final fun *.getAcquire (@target self: LSLAtomicInteger): int
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.getAndAccumulate (@target self: LSLAtomicInteger, x: int, accumulatorFunction: IntBinaryOperator): int
    {
        result = this.value;
        this.value = action CALL(accumulatorFunction, [result, x]);
    }


    @final fun *.getAndAdd (@target self: LSLAtomicInteger, delta: int): int
    {
        result = this.value;
        this.value = result + delta;
    }


    @final fun *.getAndDecrement (@target self: LSLAtomicInteger): int
    {
        result = this.value;
        this.value = result - 1;
    }


    @final fun *.getAndIncrement (@target self: LSLAtomicInteger): int
    {
        result = this.value;
        this.value = result + 1;
    }


    @final fun *.getAndSet (@target self: LSLAtomicInteger, newValue: int): int
    {
        result = this.value;
        this.value = newValue;
    }


    @final fun *.getAndUpdate (@target self: LSLAtomicInteger, updateFunction: IntUnaryOperator): int
    {
        result = this.value;
        this.value = action CALL(updateFunction, [result]);
    }


    @final fun *.getOpaque (@target self: LSLAtomicInteger): int
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.getPlain (@target self: LSLAtomicInteger): int
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.incrementAndGet (@target self: LSLAtomicInteger): int
    {
        result = this.value + 1;
        this.value = result;
    }


    fun *.intValue (@target self: LSLAtomicInteger): int
    {
        result = this.value;
    }


    @final fun *.lazySet (@target self: LSLAtomicInteger, newValue: int): void
    {
        // #problem: unable to delay variable update
        this.value = newValue;
    }


    fun *.longValue (@target self: LSLAtomicInteger): long
    {
        result = this.value as long;
    }


    @final fun *.set (@target self: LSLAtomicInteger, newValue: int): void
    {
        this.value = newValue;
    }


    @final fun *.setOpaque (@target self: LSLAtomicInteger, newValue: int): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    @final fun *.setPlain (@target self: LSLAtomicInteger, newValue: int): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    @final fun *.setRelease (@target self: LSLAtomicInteger, newValue: int): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    // within java.lang.Number
    fun *.shortValue (@target self: LSLAtomicInteger): short
    {
        result = this.value as short;
    }


    fun *.toString (@target self: LSLAtomicInteger): String
    {
        result = action OBJECT_TO_STRING(this.value);
    }


    @final fun *.updateAndGet (@target self: LSLAtomicInteger, updateFunction: IntUnaryOperator): int
    {
        result = action CALL(updateFunction, [this.value]);
        this.value = result;
    }


    @final fun *.weakCompareAndSet (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): boolean
    {
        // #problem: unable to delay variable update
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetAcquire (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetPlain (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetRelease (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetVolatile (@target self: LSLAtomicInteger, expectedValue: int, newValue: int): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }

}
