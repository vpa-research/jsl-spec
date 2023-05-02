libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

// imports

// import java-common;
// import java/lang/_interfaces;
// import java/util/function/_interfaces;
// import java/util/stream/_interfaces;


// local semantic types



// automata

// @WrapperMeta(src="java.util.OptionalDouble", dst="ru.spbpu.libsl.overrides.collections.OptionalDouble")
@public @final automaton OptionalDouble: int
{ // (
    var value: double = 0;
    var present: boolean = false;
// )
// {
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalDouble (),
        OptionalDouble (double),

        // static methods
        empty,
        of,
    ];

    shift Initialized -> self by [
        // read operations
        getAsDouble,
        isPresent,
        isEmpty,
        ifPresent,
        ifPresentOrElse,
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

    @private constructor OptionalDouble ()
    {
        action ERROR("Private constructor call");
    }


    @private constructor OptionalDouble (x: double)
    {
        action ERROR("Private constructor call");
    }


    // utilities

    @CacheStaticOnce
    @static proc _makeEmpty (): OptionalDouble
    {
        // #problem
        result = new OptionalDouble(state=Initialized);
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // static methods

    @static fun empty (): OptionalDouble
    {
        result = _makeEmpty();
    }


    @static fun of (x: double): OptionalDouble
    {
        result = new OptionalDouble(state=Initialized, value=x, present=true);
    }


    // methods

    fun equals (other: Object): boolean
    {
        if (other == this)
        {
            result = true;
        }
        else
        {
            val isSameType: boolean = action OBJECT_SAME_TYPE(this, other);
            if (isSameType)
            {
                val otherValue: double = OptionalDouble(other).value;
                val otherPresent: boolean = OptionalDouble(other).present;

                if (this.present && otherPresent)
                    {result = this.value == otherValue;}  // #problem
                else
                    {result = this.present == otherPresent;}
            }
            else
            {
                result = false;
            }
        }
    }


    fun getAsDouble (): double
    {
        if (!this.present)
            {action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);}

        result = this.value;
    }


    fun hashCode (): int
    {
        if (this.present)
            {result = action OBJECT_HASH_CODE(this.value);}
        else
            {result = 0;}
    }


    fun ifPresent (consumer: DoubleConsumer): void
    {
        requires !this.present || (this.present && consumer != null);

        if (this.present)
        {
            if (consumer == null)
                {_throwNPE();}

            action CALL(consumer, [this.value]);
        }
    }


    fun ifPresentOrElse (consumer: DoubleConsumer, emptyAction: Runnable): void
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


    fun isEmpty (): boolean
    {
        result = this.present == false;
    }


    fun isPresent (): boolean
    {
        result = this.present == true;
    }


    fun orElse (other: double): double
    {
        if (this.present)
            {result = this.value;}
        else
            {result = other;}
    }


    fun orElseGet (supplier: DoubleSupplier): double
    {
        requires supplier != null;

        if (supplier == null)
            {_throwNPE();}

        if (this.present)
            {result = this.value;}
        else
            {result = action CALL(supplier, []);}
    }


    fun orElseThrow (): double
    {
        requires this.present;

        if (!this.present)
            {action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);}

        result = this.value;
    }


    @Parametrized("X extends java.lang.Throwable")
    //@throws(generic=true)
    fun orElseThrow (@Parametrized("? extends X") exceptionSupplier: Supplier): double
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


    fun stream (): DoubleStream
    {
        action NOT_IMPLEMENTED();

        /*
        if (this.present)
            result = DoubleStream.of(this.value); // #problem
        else
            result = DoubleStream.empty(); // #problem
        */
    }


    fun toString (): String
    {
        if (this.present)
        {
            val valueStr: string = action OBJECT_TO_STRING(this.value);
            result = "OptionalDouble[" + valueStr + "]";
        }
        else
        {
            result = "OptionalDouble.empty";
        }
    }

}
