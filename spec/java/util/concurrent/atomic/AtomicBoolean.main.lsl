libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicBoolean.java";

// imports

import java/lang/String;
import java/util/concurrent/atomic/AtomicBoolean;


// automata

automaton AtomicBooleanAutomaton
(
    @private @volatile var value: int = 0, // WARNING: do not rename or change the type!
)
: LSLAtomicBoolean
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        LSLAtomicBoolean (LSLAtomicBoolean),
        LSLAtomicBoolean (LSLAtomicBoolean, boolean),
    ];

    shift Initialized -> self by [
        // instance methods
        compareAndExchange,
        compareAndExchangeAcquire,
        compareAndExchangeRelease,
        compareAndSet,
        get,
        getAcquire,
        getAndSet,
        getOpaque,
        getPlain,
        lazySet,
        set,
        setOpaque,
        setPlain,
        setRelease,
        toString,
        weakCompareAndSet,
        weakCompareAndSetAcquire,
        weakCompareAndSetPlain,
        weakCompareAndSetRelease,
        weakCompareAndSetVolatile,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.LSLAtomicBoolean (@target self: LSLAtomicBoolean)
    {
        this.value = FALSE;
    }


    constructor *.LSLAtomicBoolean (@target self: LSLAtomicBoolean, initialValue: boolean)
    {
        if (initialValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    // static methods

    // methods

    @final fun *.compareAndExchange (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        result = this.value != FALSE;
        if (result == expectedValue)
        {
            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
    }


    @final fun *.compareAndExchangeAcquire (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: unable to model memory effects here
        result = this.value != FALSE;
        if (result == expectedValue)
        {
            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
    }


    @final fun *.compareAndExchangeRelease (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: unable to model memory effects here
        result = this.value != FALSE;
        if (result == expectedValue)
        {
            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
    }


    @final fun *.compareAndSet (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        val currentValue: boolean = this.value != FALSE;
        if (currentValue == expectedValue)
        {
            result = true;

            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
        else
        {
            result = false;
        }
    }


    @final fun *.get (@target self: LSLAtomicBoolean): boolean
    {
        // NOTE: same as in the original
        result = this.value != FALSE;
    }


    @final fun *.getAcquire (@target self: LSLAtomicBoolean): boolean
    {
        // #problem: unable to model memory effects here
        result = this.value != FALSE;
    }


    @final fun *.getAndSet (@target self: LSLAtomicBoolean, newValue: boolean): boolean
    {
        result = this.value != FALSE;

        if (newValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    @final fun *.getOpaque (@target self: LSLAtomicBoolean): boolean
    {
        // #problem: unable to model memory effects here
        result = this.value != FALSE;
    }


    @final fun *.getPlain (@target self: LSLAtomicBoolean): boolean
    {
        result = this.value != FALSE;
    }


    @final fun *.lazySet (@target self: LSLAtomicBoolean, newValue: boolean): void
    {
        // #problem: delayed assignment in multithreaded environment
        if (newValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    @final fun *.set (@target self: LSLAtomicBoolean, newValue: boolean): void
    {
        if (newValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    @final fun *.setOpaque (@target self: LSLAtomicBoolean, newValue: boolean): void
    {
        // #problem: unable to model memory effects here
        if (newValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    @final fun *.setPlain (@target self: LSLAtomicBoolean, newValue: boolean): void
    {
        // #problem: unable to model memory effects here
        if (newValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    @final fun *.setRelease (@target self: LSLAtomicBoolean, newValue: boolean): void
    {
        // #problem: unable to model memory effects here
        if (newValue)
            this.value = TRUE;
        else
            this.value = FALSE;
    }


    fun *.toString (@target self: LSLAtomicBoolean): String
    {
        if (this.value == FALSE)
            result = "false";
        else
            result = "true";
    }


    fun *.weakCompareAndSet (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: delayed assignment in multithreaded environment
        val currentValue: boolean = this.value != FALSE;
        if (currentValue == expectedValue)
        {
            result = true;

            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
        else
        {
            result = false;
        }
    }


    @final fun *.weakCompareAndSetAcquire (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: delayed assignment in multithreaded environment
        val currentValue: boolean = this.value != FALSE;
        if (currentValue == expectedValue)
        {
            result = true;

            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
        else
        {
            result = false;
        }
    }


    fun *.weakCompareAndSetPlain (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: delayed assignment in multithreaded environment
        val currentValue: boolean = this.value != FALSE;
        if (currentValue == expectedValue)
        {
            result = true;

            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
        else
        {
            result = false;
        }
    }


    @final fun *.weakCompareAndSetRelease (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: delayed assignment in multithreaded environment
        val currentValue: boolean = this.value != FALSE;
        if (currentValue == expectedValue)
        {
            result = true;

            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
        else
        {
            result = false;
        }
    }


    @final fun *.weakCompareAndSetVolatile (@target self: LSLAtomicBoolean, expectedValue: boolean, newValue: boolean): boolean
    {
        // #problem: delayed assignment in multithreaded environment
        val currentValue: boolean = this.value != FALSE;
        if (currentValue == expectedValue)
        {
            result = true;

            if (newValue)
                this.value = TRUE;
            else
                this.value = FALSE;
        }
        else
        {
            result = false;
        }
    }

}
