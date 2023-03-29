libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

// imports

import "list-actions.lsl";

import "java-common.lsl";
import "java/lang/interfaces.lsl";
import "java/util/interfaces.lsl";
import "java/util/function/interfaces.lsl";
import "java/util/stream/interfaces.lsl";


// local semantic types

// #problem
@TypeMapping(typeVariable=true) typealias T = Object;


// automata

@Generic("T")
@WrapperMeta(
    src="java.util.Optional",
    dst="ru.spbpu.libsl.overrides.collections.Optional",
)
@public @final automaton Optional: int
(
    var value: Object = null;
)
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

    constructor Optional ()
    {
        assigns self.value;
        ensures self.value == null;

        value = null;
    }


    constructor Optional (obj: T)
    {
        required obj != null;
        assigns self.value;
        ensures self.value == obj;

        if (obj == null)
            self._throwNPE();

        value = obj;
    }


    // utilities

    @CacheStaticOnce
    @static proc _makeEmpty (): Optional
    {
        // #problem
        result = new Optional(state=Initialized);
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // static methods

    // #problem
    @Generic("T")
    @GenericResult("T")
    @static fun empty (): Optional  // #problem
    {
        result = _makeEmpty();
    }


    @Generic("T")
    @GenericResult("T")
    @static fun of (obj: T): Optional
    {
        if (obj == null)
            self._throwNPE();

        result = new Optional(state=Initialized, value=obj);
    }


    @Generic("T")
    @GenericResult("T")
    @static fun ofNullable (obj: T): Optional
    {
        if (obj == null)
            result = _makeEmpty();
        else
            result = new Optional(state=Initialized, value=obj);
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
                // #problem
                val otherValue = Optional(other).value;
                result = self.value == otherValue;
            }
            else
            {
                result = false;
            }
        }
    }


    @GenericResult("T")
    fun filter (@Generic("? super T") predicate: Predicate): Optional
    {
        required predicate != null;

        if (predicate == null)
            self._throwNPE();

        if (value == null)
        {
            result = self; // #problem
        }
        else
        {
            val sat: boolean = action CALL(predicate, [value]);

            if (sat)
                result = self; // #problem
            else
                result = _makeEmpty();
        }
    }


    @Generic("U")
    @GenericResult("U")
    // #problem
    fun flatMap (@Generic("? super T, ? extends Optional<? extends U>") mapper: Function): Optional
    {
        required mapper != null;

        if (mapper == null)
            self._throwNPE();

        if (value == null)
        {
            result = _makeEmpty();
        }
        else
        {
            result = action CALL(mapper, [value]);

            if (result == null)
                self._throwNPE();
        }
    }


    fun get (): T
    {
        if (value == null)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    fun hashCode (): int
    {
        result = action OBJECT_HASH_CODE(value);
    }


    fun ifPresent (@Generic("? super T") consumer: Consumer): void
    {
        required value == null || (value != null && consumer != null);

        if (value != null)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [value]);
        }
    }


    fun ifPresentOrElse (@Generic("? super T") consumer: Consumer, emptyAction: Runnable): void
    {
        required value == null || (value != null && consumer != null);
        required value != null || (value == null && emptyAction != null);

        if (value != null)
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
        result = value == null;
    }


    fun isPresent (): boolean
    {
        result = value != null;
    }


    @Generic("U")
    @GenericResult("U")
    fun map (@Generic("? super T, ? extends U") mapper: Function): Optional
    {
        required mapper != null;

        if (mapper == null)
            self._throwNPE();

        if (value == null)
        {
            result = _makeEmpty();
        }
        else
        {
            val mappedValue = action CALL(mapper, [value]);

            if (mappedValue == null)
                result = _makeEmpty();
            else
                result = new Optional(value=mappedValue);
        }
    }


    @GenericResult("T")
    fun or (@Generic("? extends Optional<? extends T>") supplier: Supplier): Optional
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (value == null)
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
        if (value == null)
            result = other;
        else
            result = value;
    }


    fun orElseGet (@Generic("? extends T") supplier: Supplier): T
    {
        required supplier != null;

        if (supplier == null)
            self._throwNPE();

        if (value == null)
            result = action CALL(supplier, []);
        else
            result = value;
    }


    fun orElseThrow (): T
    {
        if (value == null)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = value;
    }


    @Generic("X extends Throwable")
    @throws(["X"], generic=true)
    fun orElseThrow (@Generic("? extends X") exceptionSupplier: Supplier): T
    {
        required exceptionSupplier != null;

        if (exceptionSupplier == null)
            self._throwNPE();

        if (value == null)
        {
            val exception = action CALL(exceptionSupplier, []);
            action THROW_VALUE(exception);
        }
        else
        {
            result = value;
        }
    }


    @GenericResult("T")
    fun stream (): Stream
    {
        action NOT_IMPLEMENTED();

        /*
        if (value == null)
            result = Stream.empty(); // #problem
        else
            result = Stream.of(value); // #problem
        */
    }


    fun toString (): string
    {
        if (value == null)
            result = "Optional.empty";
        else
        {
            val valueStr = action OBJECT_TO_STRING(value);
            result = "Optional[" + valueStr + "]";
        }
    }

}
