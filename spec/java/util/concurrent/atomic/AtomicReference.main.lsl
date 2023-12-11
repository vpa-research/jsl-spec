libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicReference.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/util/function/BinaryOperator;
import java/util/function/UnaryOperator;

import java/util/concurrent/atomic/AtomicReference;


// automata

automaton AtomicReferenceAutomaton
(
    @private @volatile var value: Object = null, // WARNING: do not rename!
)
: LSLAtomicReference
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (LSLAtomicReference),
        `<init>` (LSLAtomicReference, Object),
    ];

    shift Initialized -> self by [
        // instance methods
        accumulateAndGet,
        compareAndExchange,
        compareAndExchangeAcquire,
        compareAndExchangeRelease,
        compareAndSet,
        get,
        getAcquire,
        getAndAccumulate,
        getAndSet,
        getAndUpdate,
        getOpaque,
        getPlain,
        lazySet,
        set,
        setOpaque,
        setPlain,
        setRelease,
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

    constructor *.`<init>` (@target self: LSLAtomicReference)
    {
        this.value = null;
    }


    constructor *.`<init>` (@target self: LSLAtomicReference, initialValue: Object)
    {
        this.value = initialValue;
    }


    // static methods

    // methods

    @final fun *.accumulateAndGet (@target self: LSLAtomicReference, x: Object, accumulatorFunction: BinaryOperator): Object
    {
        result = action CALL(accumulatorFunction, [this.value, x]);
        this.value = result;
    }


    @final fun *.compareAndExchange (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): Object
    {
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndExchangeAcquire (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): Object
    {
        // #problem: unable to model memory side-effects
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndExchangeRelease (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): Object
    {
        // #problem: unable to model memory side-effects
        result = this.value;
        if (result == expectedValue)
            this.value = newValue;
    }


    @final fun *.compareAndSet (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): boolean
    {
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.get (@target self: LSLAtomicReference): Object
    {
        result = this.value;
    }


    @final fun *.getAcquire (@target self: LSLAtomicReference): Object
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.getAndAccumulate (@target self: LSLAtomicReference, x: Object, accumulatorFunction: BinaryOperator): Object
    {
        result = this.value;
        this.value = action CALL(accumulatorFunction, [result, x]);
    }


    @final fun *.getAndSet (@target self: LSLAtomicReference, newValue: Object): Object
    {
        result = this.value;
        this.value = newValue;
    }


    @final fun *.getAndUpdate (@target self: LSLAtomicReference, updateFunction: UnaryOperator): Object
    {
        result = this.value;
        this.value = action CALL(updateFunction, [result]);
    }


    @final fun *.getOpaque (@target self: LSLAtomicReference): Object
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.getPlain (@target self: LSLAtomicReference): Object
    {
        // #problem: unable to model memory side-effects
        result = this.value;
    }


    @final fun *.lazySet (@target self: LSLAtomicReference, newValue: Object): void
    {
        // #problem: unable to delay variable update
        this.value = newValue;
    }


    @final fun *.set (@target self: LSLAtomicReference, newValue: Object): void
    {
        this.value = newValue;
    }


    @final fun *.setOpaque (@target self: LSLAtomicReference, newValue: Object): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    @final fun *.setPlain (@target self: LSLAtomicReference, newValue: Object): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    @final fun *.setRelease (@target self: LSLAtomicReference, newValue: Object): void
    {
        // #problem: unable to model memory side-effects
        this.value = newValue;
    }


    fun *.toString (@target self: LSLAtomicReference): String
    {
        result = action OBJECT_TO_STRING(this.value);
    }


    @final fun *.updateAndGet (@target self: LSLAtomicReference, updateFunction: UnaryOperator): Object
    {
        result = action CALL(updateFunction, [this.value]);
        this.value = result;
    }


    @final fun *.weakCompareAndSet (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): boolean
    {
        // #problem: unable to delay variable update
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetAcquire (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetPlain (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetRelease (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }


    @final fun *.weakCompareAndSetVolatile (@target self: LSLAtomicReference, expectedValue: Object, newValue: Object): boolean
    {
        // #problem: unable to model memory side-effects
        result = this.value == expectedValue;
        if (result)
            this.value = newValue;
    }

}
