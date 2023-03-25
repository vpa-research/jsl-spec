libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

// imports

import "list-actions.lsl";

import "java-common.lsl";
import "java/lang/interfaces.lsl"
import "java/util/interfaces.lsl"
import "java/util/function/interfaces.lsl"


// automata

@WrapperMeta(
    src="java.util.Optional",
    dst="ru.spbpu.libsl.overrides.collections.Optional",
)
@public @final automaton Optional: int
(
    var value: object = null;
)
{
    initstate Allocated;
    state Initialized;

    // constructors
    shift Allocated -> Initialized by [
        Optional(),
        Optional(Object),
    ];

    // static methods
    shift Allocated -> self by [
        empty,
        of,
        ofNullable,
    ];

    shift Initialized -> self by [
        // read operations
        get,
        getOrDefault,
        containsKey,
        containsValue,
        size,
        isEmpty,
        toString,
        hashCode,

        clone,
        keySet,
    ];


    // constructors

    constructor Optional ()
    {
        assigns self.value;
        ensures self.value == null;

        value = null;
    }


    constructor Optional (obj: Object)
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
        result = new Optional();
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // methods

    @static fun empty (): Optional  // #problem
    {
        result = _makeEmpty();
    }


    // #problem
    @static fun of (obj: Object): Optional
    {
        result = new Optional(value=obj);
    }


    // #problem
    @static fun ofNullable (obj: Object): Optional
    {
        if (obj == null)
            result = _makeEmpty();
        else
            result = new Optional(obj);
    }


    fun get (): Object
    {
        if (value == null)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = value;
    }


    fun isPresent (): boolean
    {
        result = value != null;
    }


    fun isEmpty (): boolean
    {
        result = value == null;
    }


    fun ifPresent (consumer: Consumer): void
    {
        required value == null || (value != null && consumer != null);

        if (value != null)
        {
            if (consumer == null)
                self._throwNPE();

            action CALL(consumer, [value]);
        }
    }


    fun ifPresentOrElse (consumer: Consumer, emptyAction: Runnable): void
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


    fun filter (predicate: Predicate): Optional
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


    fun map (mapper: Function): Optional
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


    fun flatMap (mapper: Function): Optional
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


    fun toString (): string
    {
        action NOT_IMPLEMENTED();
    }


    fun hashCode (): int
    {
        result = action OBJECT_HASH_CODE(value);
    }


    fun equals (other: Object): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }

}

