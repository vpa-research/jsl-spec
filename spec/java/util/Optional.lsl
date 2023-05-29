//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

@Parameterized("T")
@public @final type Optional is java.util.Optional for Object
{
    var value: T;
)

@TypeMapping(typeVariable=true) typealias T = Object; // #problem


// automata

@Parameterized(["T"])
automaton OptionalAutomaton (
    var value: T = null
): Optional
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        Optional (),
        Optional (T),

        // static methods
        empty,
        of,
        ofNullable,
    ];

    shift Initialized -> self by [
        // read operations
        get,
        isPresent,
        isEmpty,
        ifPresent,
        ifPresentOrElse,
        filter,
        map,
        flatMap,
        or,
        stream,
        orElse,
        orElseGet,
        orElseThrow (),
        orElseThrow (Supplier),
        toString,
        hashCode,
        equals,
    ];


    // constructors

    @private constructor Optional ()
    {
        action ERROR("Private constructor call");
        /*assigns self.value;
        ensures self.value == null;

        value = null;*/
    }


    @private constructor Optional (obj: T)
    {
        action ERROR("Private constructor call");
        /*required obj != null;
        assigns self.value;
        ensures self.value == obj;

        if (obj == null)
            self._throwNPE();

        value = obj;*/
    }


    // utilities

    @CacheStaticOnce
    @static proc _makeEmpty (): Optional
    {
        // #problem
        result = new OptionalAutomaton(state=Initialized);
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // static methods

    // #problem
    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    @static fun empty (): Optional  // #problem
    {
        result = _makeEmpty();
    }


    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    @static fun of (obj: T): Optional
    {
        required obj != null;

        if (obj == null)
            {_throwNPE();}

        result = new OptionalAutomaton(state=Initialized, value=obj);
    }


    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    @static fun ofNullable (obj: T): Optional
    {
        if (obj == null)
        {
            result = _makeEmpty();
        }
        else
        {
            result = new OptionalAutomaton(state=Initialized, value=obj);
        }
    }


    // methods

    fun equals (other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            val isSameType: boolean = action OBJECT_SAME_TYPE(self, other);
            if (isSameType)
            {
                val otherValue: Object = OptionalAutomaton(other).value;  // #problem
                result = this.value == otherValue;
            }
            else
            {
                result = false;
            }
        }
    }


    @ParameterizedResult(["T"])
    fun filter (@Parameterized(["? super T"]) predicate: Predicate): Optional
    {
        required predicate != null;

        if (predicate == null)
            {_throwNPE();}

        if (this.value == null)
        {
            result = self; // #problem
        }
        else
        {
            val sat: boolean = action CALL(predicate, [this.value]);

            if (sat)
                result = self; // #problem
            else
                result = _makeEmpty();
        }
    }


    @Parameterized(["U"])
    @ParameterizedResult(["U"])
    // #problem
    fun flatMap (@Parameterized(["? super T"], ["? extends Optional<? extends U>"]) mapper: Function): Optional
    {
        required mapper != null;

        if (mapper == null)
            self._throwNPE();

        if (this.value == null)
        {
            result = _makeEmpty();
        }
        else
        {
            result = action CALL(mapper, [this.value]);

            if (result == null)
                self._throwNPE();
        }
    }


    fun get (): T
    {
        if (this.value == null)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    fun hashCode (): int
    {
        result = action OBJECT_HASH_CODE(value);
    }


    fun ifPresent (@Parameterized("? super T") consumer: Consumer): void
    {
        required this.value == null || (this.value != null && consumer != null);

        if (this.value != null)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [this.value]);
        }
    }


    fun ifPresentOrElse (@Parameterized("? super T") consumer: Consumer, emptyAction: Runnable): void
    {
        required this.value == null || (this.value != null && consumer != null);
        required this.value != null || (this.value == null && emptyAction != null);

        if (this.value != null)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [this.value]);
        }
        else
        {
            if (emptyAction == null)
                self._throwNPE();

            action CALL(emptyAction, []);
        }
    }


    fun isEmpty (): boolean
    {
        result = this.value == null;
    }


    fun isPresent (): boolean
    {
        result = this.value != null;
    }


    @Parameterized(["U"])
    @ParameterizedResult(["U"])
    fun map (@Parameterized(["? super T"], ["? extends U"]) mapper: Function): Optional
    {
        required mapper != null;

        if (mapper == null)
            {_throwNPE();}

        if (this.value == null)
        {
            result = _makeEmpty();
        }
        else
        {
            val mappedValue: Object = action CALL(mapper, [this.value]);

            if (mappedValue == null)
                result = _makeEmpty();
            else
                result = new OptionalAutomaton(value=mappedValue);
        }
    }


    @ParameterizedResult(["T"])
    fun or (@Parameterized(["? extends Optional<? extends T>"]) supplier: Supplier): Optional
    {
        required supplier != null;

        if (supplier == null)
            {_throwNPE();}

        if (this.value == null)
        {
            result = action CALL(supplier, []);

            if (result == null)
                self._throwNPE();
        }
        else
        {
            result = self;
        }
    }


    fun orElse (other: T): T
    {
        if (this.value == null)
            result = other;
        else
            result = this.value;
    }


    fun orElseGet (@Parameterized(["? extends T"]) supplier: Supplier): T
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (this.value == null)
            result = action CALL(supplier, []);
        else
            result = this.value;
    }


    fun orElseThrow (): T
    {
        required this.value != null;

        if (this.value == null)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["X"])
    fun orElseThrow (@Parameterized(["? extends X"]) exceptionSupplier: Supplier): T
    {
        required exceptionSupplier != null;

        if (exceptionSupplier == null)
            {_throwNPE();}

        if (this.value == null)
        {
            val exception: Object = action CALL(exceptionSupplier, []);
            action THROW_VALUE(exception);
        }
        else
        {
            result = this.value;
        }
    }


    @ParameterizedResult(["T"])
    fun stream (): Stream
    {
        action NOT_IMPLEMENTED();

        /*
        if (this.value == null)
            result = Stream.empty(); // #problem
        else
            result = Stream.of(this.value); // #problem
        */
    }


    fun toString (): string
    {
        if (this.value == null)
        {
            result = "Optional.empty";
        }
        else
        {
            val valueStr: string = action OBJECT_TO_STRING(this.value);
            result = "Optional[" + valueStr + "]";
        }
    }

}
