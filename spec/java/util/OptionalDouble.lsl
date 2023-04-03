libsl "1.1.0";

library "std:collections"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/lang/_interfaces.lsl";
import "java/util/function/_interfaces.lsl";
import "java/util/stream/_interfaces.lsl";


// local semantic types



// automata

@WrapperMeta(
    src="java.util.OptionalDouble",
    dst="ru.spbpu.libsl.overrides.collections.OptionalDouble",
)
@public @final automaton OptionalDouble: double
(
    var value: double = 0;
    var present: boolean = false;
)
{
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
        ofNullable,
    ];

    shift Initialized -> self by [
        // read operations
        getAsDouble,
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
        if (other == self)
        {
            result = true;
        }
        else
        {
            val isSameType = action OBJECT_SAME_TYPE(self, other);
            if (isSameType)
            {
                val otherValue = OptionalDouble(other).value;
                val otherPresent = OptionalDouble(other).present;
                // #problem
                result = self.value == otherValue && self.present == otherPresent;
            }
            else
            {
                result = false;
            }
        }
    }


    fun getAsDouble (): double
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    fun hashCode (): int
    {
        result = action OBJECT_HASH_CODE(value);
    }


    fun ifPresent (consumer: DoubleConsumer): void
    {
        required !present || (present && consumer != null);

        if (present)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [value]);
        }
    }


    fun ifPresentOrElse (consumer: DoubleConsumer, emptyAction: Runnable): void
    {
        required !present || (present  && consumer != null);
        required present  || (!present && emptyAction != null);

        if (present)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [value]);
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
        result = present == false;
    }


    fun isPresent (): boolean
    {
        result = present == true;
    }


    fun orElse (other: double): double
    {
        if (present)
            result = value;
        else
            result = other;
    }


    fun orElseGet (supplier: DoubleSupplier): double
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (present)
            result = value;
        else
            result = action CALL(supplier, []);
    }


    fun orElseThrow (): double
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    @Generic("X extends Throwable")
    @throws(["X"], generic=true)
    fun orElseThrow (@Generic("? extends X") exceptionSupplier: Supplier): double
    {
        required exceptionSupplier != null;

        if (exceptionSupplier == null)
            self._throwNPE();

        if (!present)
        {
            val exception = action CALL(exceptionSupplier, []);
            action THROW_VALUE(exception);
        }
        else
        {
            result = value;
        }
    }


    fun stream (): DoubleStream
    {
        action NOT_IMPLEMENTED();

        /*
        if (present)
            result = DoubleStream.of(value); // #problem
        else
            result = DoubleStream.empty(); // #problem
        */
    }


    fun toString (): String
    {
        if (present)
        {
            val valueStr = action OBJECT_TO_STRING(value);
            result = "Optional[" + valueStr + "]";
        }
        else
        {
            result = "Optional.empty";
        }
    }

}
