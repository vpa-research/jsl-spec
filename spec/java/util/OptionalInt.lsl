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
    src="java.util.OptionalInt",
    dst="ru.spbpu.libsl.overrides.collections.OptionalInt",
)
@public @final automaton OptionalInt: int
(
    var value: int = 0;
    var present: boolean = false;
)
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalInt (),
        OptionalInt (int),

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
        orElseThrow (),
        orElseThrow (Supplier),
        toString,
        hashCode,
        equals,
    ];


    // constructors

    @private constructor OptionalInt ()
    {
        action ERROR("Private constructor call");
    }


    @private constructor OptionalInt (x: int)
    {
        action ERROR("Private constructor call");
    }


    // utilities

    @CacheStaticOnce
    @static proc _makeEmpty (): OptionalInt
    {
        // #problem
        result = new OptionalInt(state=Initialized);
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // static methods

    @static fun empty (): OptionalInt
    {
        result = _makeEmpty();
    }


    @static fun of (x: int): OptionalInt
    {
        result = new OptionalInt(state=Initialized, value=x, present=true);
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
                val otherValue = OptionalInt(other).value;
                val otherPresent = OptionalInt(other).present;
                result = self.value == otherValue && self.present == otherPresent;
            }
            else
            {
                result = false;
            }
        }
    }


    fun getAsInt (): int
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    fun hashCode (): int
    {
        result = action OBJECT_HASH_CODE(value);
    }


    fun ifPresent (consumer: IntConsumer): void
    {
        required !present || (present && consumer != null);

        if (present)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [value]);
        }
    }


    fun ifPresentOrElse (consumer: IntConsumer, emptyAction: Runnable): void
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


    fun orElse (other: int): int
    {
        if (present)
            result = value;
        else
            result = other;
    }


    fun orElseGet (supplier: IntSupplier): int
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (present)
            result = value;
        else
            result = action CALL(supplier, []);
    }


    fun orElseThrow (): int
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    @Generic("X extends Throwable")
    @throws(["X"], generic=true)
    fun orElseThrow(@Generic("? extends X") exceptionSupplier: Supplier): int
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


    fun stream (): IntStream
    {
        action NOT_IMPLEMENTED();

        /*
        if (present)
            result = IntStream.of(value); // #problem
        else
            result = IntStream.empty(); // #problem
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
