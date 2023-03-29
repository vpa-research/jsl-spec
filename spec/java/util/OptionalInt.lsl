libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

// imports

import "list-actions.lsl";

import "java-common.lsl";
import "java/lang/interfaces.lsl";
import "java/util/interfaces.lsl";
import "java/util/function/interfaces.lsl";
import "java/util/stream/interfaces.lsl";


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
    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalInt (),
        OptionalInt (int),

        // static methods
        empty,
        of,
        ofNullable,
    ];

    shift Initialized -> self by [
        // read operations
        getAsInt,
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

    constructor OptionalInt ()
    {
        assigns self.value;
        assigns self.present;
        ensures self.value == 0;
        ensures self.present == false;

        value = 0;
        present = false;
    }


    constructor OptionalInt (obj: int)
    {
        assigns self.value;
        assigns self.present;
        ensures self.value == obj;
        ensures self.present == true;

        value = obj;
        present = true;
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


    // methods

    @static fun empty (): OptionalInt  // #problem
    {
        result = _makeEmpty();
    }


    @static fun of (obj: int): OptionalInt
    {
        result = new OptionalInt(state=Initialized, value=obj, present=true);
    }


    fun getAsInt (): int
    {
        if (!present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    fun isPresent (): boolean
    {
        result = present == true;
    }


    fun isEmpty (): boolean
    {
        result = present == false;
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


    fun or (@Generic("? extends OptionalInt") supplier: Supplier): OptionalInt
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (present)
        {
            result = self;
        }
        else
        {
            result = action CALL(supplier, []);

            if (result == null)
                self._throwNPE();
        }
    }


    @GenericResult("T")
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
    @throws("X", generic=true)
    fun orElseThrow(@Generic("? extends X") exceptionSupplier: Supplier): T
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


    fun toString (): string
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


    fun hashCode (): int
    {
        result = action OBJECT_HASH_CODE(value);
    }


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
                // #problem
                val otherValue = OptionalInt(other).value;
                result = self.value == otherValue;
            }
            else
            {
                result = false;
            }
        }
    }

}

