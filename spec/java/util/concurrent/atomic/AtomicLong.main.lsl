libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicLong.java";

// imports

import java/lang/String;
import java/util/function/LongBinaryOperator;
import java/util/function/LongUnaryOperator;

import java/util/concurrent/atomic/AtomicLong;


// automata

automaton AtomicLongAutomaton
(
    @private @volatile var value: long = 0L, // WARNING: do not rename!
)
: LSLAtomicLong
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (LSLAtomicLong),
        `<init>` (LSLAtomicLong, long),
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

    constructor *.`<init>` (@target self: LSLAtomicLong)
    {
        this.value = 0L;
    }


    constructor *.`<init>` (@target self: LSLAtomicLong, initialValue: long)
    {
        this.value = initialValue;
    }


    // static methods

    // methods

    @final fun *.accumulateAndGet (@target self: LSLAtomicLong, x: long, accumulatorFunction: LongBinaryOperator): long
    {
        result = action CALL(accumulatorFunction, [this.value, x]);
        this.value = result;
    }


    @final fun *.addAndGet (@target self: LSLAtomicLong, delta: long): long
    {
        result = this.value + delta;
        this.value = result;
    }


    // within java.lang.Number
    fun *.byteValue (@target self: LSLAtomicLong): byte
    {
        result = this.value as byte;
    }


    @final fun *.compareAndExchange (@target self: LSLAtomicLong, expectedValue: long, newValue: long): long
    {
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndExchangeAcquire (@target self: LSLAtomicLong, expectedValue: long, newValue: long): long
    {
        // #problem: unable to model memory side-effects
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndExchangeRelease (@target self: LSLAtomicLong, expectedValue: long, newValue: long): long
    {
        // #problem: unable to model memory side-effects
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndSet (@target self: LSLAtomicLong, expectedValue: long, newValue: long): boolean
    {
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.decrementAndGet (@target self: LSLAtomicLong): long
    {
        result = this.value - 1L;
        this.value = result;
    }


    fun *.doubleValue (@target self: LSLAtomicLong): double
    {
        result = this.value as double;
    }


    fun *.floatValue (@target self: LSLAtomicLong): float
    {
        result = this.value as float;
    }


    @final fun *.get (@target self: LSLAtomicLong): long
    {
        result = this.value;
    }


    @final fun *.getAcquire (@target self: LSLAtomicLong): long
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.getAndAccumulate (@target self: LSLAtomicLong, x: long, accumulatorFunction: LongBinaryOperator): long
    {
        result = this.value;
        this.value = action CALL(accumulatorFunction, [result, x]);
    }


    @final fun *.getAndAdd (@target self: LSLAtomicLong, delta: long): long
    {
        result = this.value;
        this.value = result + delta;
    }


    @final fun *.getAndDecrement (@target self: LSLAtomicLong): long
    {
        result = this.value;
        this.value = result - 1L;
    }


    @final fun *.getAndIncrement (@target self: LSLAtomicLong): long
    {
        result = this.value;
        this.value = result + 1L;
    }


    @final fun *.getAndSet (@target self: LSLAtomicLong, newValue: long): long
    {
        result = this.value;
        this.value = newValue;
    }


    @final fun *.getAndUpdate (@target self: LSLAtomicLong, updateFunction: LongUnaryOperator): long
    {
        result = this.value;
        this.value = action CALL(updateFunction, [result]);
    }


    @final fun *.getOpaque (@target self: LSLAtomicLong): long
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.getPlain (@target self: LSLAtomicLong): long
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.incrementAndGet (@target self: LSLAtomicLong): long
    {
        result = this.value + 1L;
        this.value = result;
    }


    fun *.intValue (@target self: LSLAtomicLong): int
    {
        result = this.value as int;
    }


    @final fun *.lazySet (@target self: LSLAtomicLong, newValue: long): void
    {
        // #problem: unable to delay variable update
        this.value = newValue;
    }


    fun *.longValue (@target self: LSLAtomicLong): long
    {
        result = this.value;
    }


    @final fun *.set (@target self: LSLAtomicLong, newValue: long): void
    {
        this.value = newValue;
    }


    @final fun *.setOpaque (@target self: LSLAtomicLong, newValue: long): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    @final fun *.setPlain (@target self: LSLAtomicLong, newValue: long): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    @final fun *.setRelease (@target self: LSLAtomicLong, newValue: long): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    // within java.lang.Number
    fun *.shortValue (@target self: LSLAtomicLong): short
    {
        result = this.value as short;
    }


    fun *.toString (@target self: LSLAtomicLong): String
    {
        result = action OBJECT_TO_STRING(this.value);
    }


    @final fun *.updateAndGet (@target self: LSLAtomicLong, updateFunction: LongUnaryOperator): long
    {
        result = action CALL(updateFunction, [this.value]);
        this.value = result;
    }


    @final fun *.weakCompareAndSet (@target self: LSLAtomicLong, expectedValue: long, newValue: long): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetAcquire (@target self: LSLAtomicLong, expectedValue: long, newValue: long): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetPlain (@target self: LSLAtomicLong, expectedValue: long, newValue: long): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetRelease (@target self: LSLAtomicLong, expectedValue: long, newValue: long): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetVolatile (@target self: LSLAtomicLong, expectedValue: long, newValue: long): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }

}
