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


/// TODO: remove duplicate types

type Runnable is java.lang.Runnable for Object {
    fun run (): void;
}

type LongConsumer is java.util.function.LongConsumer for Object {
    fun accept (x: long): void;
}

type LongSupplier is java.util.function.LongSupplier for Object {
    fun get (): long;
}

@Parameterized(["T"])
type Supplier is java.util.function.Supplier for Object {
    fun get (): Object;
}

type LongStream is java.util.stream.LongStream for Object {
    // ???
}

/// TODO: remove duplicate types



// local semantic types

@public @final type OptionalLong is java.util.OptionalLong for Object {
}


// automata

automaton OptionalLongAutomaton (
    var value: long,
    var present: boolean,
): OptionalLong
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalLong (OptionalLong),
        OptionalLong (OptionalLong, long),

        // static methods
        empty,
        of,
    ];

    shift Initialized -> self by [
        // read operations
        getAsLong,
        isPresent,
        isEmpty,
        ifPresent,
        ifPresentOrElse,
        stream,
        orElse,
        orElseGet,
        orElseThrow (OptionalLong),
        orElseThrow (OptionalLong, Supplier),
        toString,
        hashCode,
        equals,
    ];


    // constructors

    @private constructor OptionalLong (@target self: OptionalLong)
    {
        action ERROR("Private constructor call");
    }


    @private constructor OptionalLong (@target self: OptionalLong, x: long)
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

    @static fun empty (): OptionalLong
    {
        result = EMPTY_OPTIONAL_LONG;
    }


    @static fun of (x: long): OptionalLong
    {
        result = new OptionalLongAutomaton(state=Initialized, value=x, present=true);
    }


    // methods

    @AnnotatedWith("java.lang.Override")
    fun equals (@target self: OptionalLong, other: Object): boolean
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
                val otherValue: long = OptionalLongAutomaton(other).value;
                val otherPresent: boolean = OptionalLongAutomaton(other).present;

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


    fun getAsLong (@target self: OptionalLong): long
    {
        if (!this.present)
            {action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);}

        result = this.value;
    }


    @AnnotatedWith("java.lang.Override")
    fun hashCode (@target self: OptionalLong): int
    {
        if (this.present)
            {result = action OBJECT_HASH_CODE(this.value);}
        else
            {result = 0;}
    }


    fun ifPresent (@target self: OptionalLong, consumer: LongConsumer): void
    {
        requires !this.present || (this.present && consumer != null);

        if (this.present)
        {
            if (consumer == null)
                {_throwNPE();}

            action CALL(consumer, [this.value]);
        }
    }


    fun ifPresentOrElse (@target self: OptionalLong, consumer: LongConsumer, emptyAction: Runnable): void
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


    fun isEmpty (@target self: OptionalLong): boolean
    {
        result = this.present == false;
    }


    fun isPresent (@target self: OptionalLong): boolean
    {
        result = this.present == true;
    }


    fun orElse (@target self: OptionalLong, other: long): long
    {
        if (this.present)
            {result = this.value;}
        else
            {result = other;}
    }


    fun orElseGet (@target self: OptionalLong, supplier: LongSupplier): long
    {
        requires supplier != null;

        if (supplier == null)
            {_throwNPE();}

        if (this.present)
            {result = this.value;}
        else
            {result = action CALL(supplier, []);}
    }


    fun orElseThrow (@target self: OptionalLong): long
    {
        requires this.present;

        if (!this.present)
            {action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);}

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["X"])
    fun orElseThrow(@target self: OptionalLong, @Parameterized(["? extends X"]) exceptionSupplier: Supplier): long
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


    fun stream (@target self: OptionalLong): LongStream
    {
        action NOT_IMPLEMENTED();

        /*
        if (this.present)
            result = LongStream.of(this.value); // #problem
        else
            result = LongStream.empty(); // #problem
        */
    }


    @AnnotatedWith("java.lang.Override")
    fun toString (@target self: OptionalLong): String
    {
        if (this.present)
        {
            val valueStr: string = action OBJECT_TO_STRING(this.value);
            result = "OptionalLong[" + valueStr + "]";
        }
        else
        {
            result = "OptionalLong.empty";
        }
    }

}


// globals

// #problem: "0" should be int64
val EMPTY_OPTIONAL_LONG: OptionalLong = new OptionalLongAutomaton(state=Initialized, value=0, present=false);

