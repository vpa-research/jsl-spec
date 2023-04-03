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
    src="java.util.OptionalLong",
    dst="ru.spbpu.libsl.overrides.collections.OptionalLong",
)
@public @final automaton OptionalLong: long
(
    var value: long = 0;
    var present: boolean = false;
)
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalLong (),
        OptionalLong (long),

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
        orElseThrow (),
        orElseThrow (Supplier),
        toString,
        hashCode,
        equals,
    ];


    // constructors

    @private constructor OptionalLong ()
    {
        action ERROR("Private constructor call");
    }


    @private constructor OptionalLong (x: long)
    {
        action ERROR("Private constructor call");
    }


    // utilities

    @CacheStaticOnce
    @static proc _makeEmpty (): OptionalLong
    {
        // #problem
        result = new OptionalLong(state=Initialized);
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // static methods

    @static fun empty (): OptionalLong
    {
        result = _makeEmpty();
    }


    @static fun of (x: long): OptionalLong
    {
        result = new OptionalLong(state=Initialized, value=x, present=true);
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
                val otherValue = OptionalLong(other).value;
                val otherPresent = OptionalLong(other).present;
                result = self.value == otherValue && self.present == otherPresent;
            }
            else
            {
                result = false;
            }
        }
    }


    fun getAsLong (): long
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    fun hashCode (): int
    {
        if (present)
            result = action OBJECT_HASH_CODE(value);
        else
            result = 0;
    }


    fun ifPresent (consumer: LongConsumer): void
    {
        required !present || (present && consumer != null);

        if (present)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [value]);
        }
    }


    fun ifPresentOrElse (consumer: LongConsumer, emptyAction: Runnable): void
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


    fun orElse (other: long): long
    {
        if (present)
            result = value;
        else
            result = other;
    }


    fun orElseGet (supplier: LongSupplier): long
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (present)
            result = value;
        else
            result = action CALL(supplier, []);
    }


    fun orElseThrow (): long
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    @Generic("X extends Throwable")
    @throws(["X"], generic=true)
    fun orElseThrow(@Generic("? extends X") exceptionSupplier: Supplier): long
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


    fun stream (): LongStream
    {
        action NOT_IMPLEMENTED();

        /*
        if (present)
            result = LongStream.of(value); // #problem
        else
            result = LongStream.empty(); // #problem
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
