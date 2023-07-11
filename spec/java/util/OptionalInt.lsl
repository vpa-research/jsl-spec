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

@public @final type OptionalInt is java.util.OptionalInt for Object {
}


// automata

automaton OptionalIntAutomaton (
    var value: int,
    var present: boolean
): OptionalInt
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalInt (OptionalInt),
        OptionalInt (OptionalInt, int),

        // static methods
        empty,
        of,
    ];

    shift Initialized -> self by [
        // read operations
        getAsInt,
        isPresent,
        isEmpty,
        ifPresent,
        ifPresentOrElse,
        stream,
        orElse,
        orElseGet,
        orElseThrow (OptionalInt),
        orElseThrow (OptionalInt, Supplier),
        toString,
        hashCode,
        equals,
    ];


    // constructors

    @private constructor OptionalInt (@target self: OptionalInt)
    {
        action ERROR("Private constructor call");
    }


    @private constructor OptionalInt (@target self: OptionalInt, x: int)
    {
        action ERROR("Private constructor call");
    }


    // utilities

    @AutoInline
    @static proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // static methods

    @static fun empty (): OptionalInt
    {
        result = EMPTY_OPTIONAL_INT;
    }


    @static fun of (x: int): OptionalInt
    {
        result = new OptionalIntAutomaton(state=Initialized, value=x, present=true);
    }


    // methods

    @AnnotatedWith("java.lang.Override")
    fun equals (@target self: OptionalInt, other: Object): boolean
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
                val otherValue: int = OptionalIntAutomaton(other).value;
                val otherPresent: boolean = OptionalIntAutomaton(other).present;

                if (this.present && otherPresent)
                    {result = this.value == otherValue;}
                else
                    {result = this.present == otherPresent;}
            }
            else
            {
                result = false;
            }
        }
    }


    fun getAsInt (@target self: OptionalInt): int
    {
        if (!this.present)
            {action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);}

        result = this.value;
    }


    @AnnotatedWith("java.lang.Override")
    fun hashCode (@target self: OptionalInt): int
    {
        if (this.present)
            {result = action OBJECT_HASH_CODE(this.value);}
        else
            {result = 0;}
    }


    fun ifPresent (@target self: OptionalInt, consumer: IntConsumer): void
    {
        requires !this.present || (this.present && consumer != null);

        if (this.present)
        {
            if (consumer == null)
                {_throwNPE();}

            action CALL(consumer, [this.value]);
        }
    }


    fun ifPresentOrElse (@target self: OptionalInt, consumer: IntConsumer, emptyAction: Runnable): void
    {
        requires !this.present || (this.present  && consumer != null);
        requires this.present  || (!this.present && emptyAction != null);

        if (this.present)
        {
            if (consumer == null)
                {_throwNPE();}

            action CALL(consumer, [this.value]);
        }
        else
        {
            if (emptyAction == null)
                {_throwNPE();}

            action CALL(emptyAction, []);
        }
    }


    fun isEmpty (@target self: OptionalInt): boolean
    {
        result = this.present == false;
    }


    fun isPresent (@target self: OptionalInt): boolean
    {
        result = this.present == true;
    }


    fun orElse (@target self: OptionalInt, other: int): int
    {
        if (this.present)
            {result = this.value;}
        else
            {result = other;}
    }


    fun orElseGet (@target self: OptionalInt, supplier: IntSupplier): int
    {
        requires supplier != null;

        if (supplier == null)
            {_throwNPE();}

        if (this.present)
            {result = this.value;}
        else
            {result = action CALL(supplier, []);}
    }


    fun orElseThrow (@target self: OptionalInt): int
    {
        requires this.present;

        if (!this.present)
            {action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);}

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["X"])
    fun orElseThrow(@target self: OptionalInt, @Parameterized(["? extends X"]) exceptionSupplier: Supplier): int
    {
        requires exceptionSupplier != null;

        if (exceptionSupplier == null)
            {_throwNPE();}

        if (!this.present)
        {
            val exception: Object = action CALL(exceptionSupplier, []);
            action THROW_VALUE(exception);
        }
        else
        {
            result = this.value;
        }
    }


    fun stream (@target self: OptionalInt): IntStream
    {
        action NOT_IMPLEMENTED();

        /*
        if (this.present)
            result = IntStream.of(this.value); // #problem
        else
            result = IntStream.empty(); // #problem
        */
    }


    @AnnotatedWith("java.lang.Override", [])
    fun toString (@target self: OptionalInt): String
    {
        if (this.present)
        {
            val valueStr: string = action OBJECT_TO_STRING(this.value);
            result = "OptionalInt[" + valueStr + "]";
        }
        else
        {
            result = "OptionalInt.empty";
        }
    }

}


// globals

val EMPTY_OPTIONAL_INT: OptionalInt = new OptionalIntAutomaton(state=Initialized, value=0, present=false);

