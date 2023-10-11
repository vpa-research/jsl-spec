///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Optional.java";

// imports

import java/lang/Object;
import java/lang/Runnable;
import java/util/function/Consumer;
import java/util/function/Predicate;
import java/util/Optional;


// globals

// #problem: type parameter is missing
val EMPTY_OPTIONAL: LSLOptional = new OptionalAutomaton(state=Initialized, value=null);


// automata

@Parameterized(["T"])
automaton OptionalAutomaton
(
    var value: Object
)
: LSLOptional
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        LSLOptional (LSLOptional),
        LSLOptional (LSLOptional, Object),

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
        orElseThrow (LSLOptional),
        orElseThrow (LSLOptional, Supplier),
        toString,
        hashCode,
        equals,
    ];


    // utilities

    @static proc _makeEmpty (): LSLOptional
    {
        result = EMPTY_OPTIONAL;
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // constructors

    @private constructor *.LSLOptional (@target @Parameterized(["T"]) self: LSLOptional)
    {
        action ERROR("Private constructor call");
        /*assigns this.value;
        ensures this.value == null;

        this.value = null;*/
    }


    @private constructor *.LSLOptional (@target @Parameterized(["T"]) self: LSLOptional, obj: Object)
    {
        action ERROR("Private constructor call");
        /*requires obj != null;
        assigns this.value;
        ensures this.value == obj;

        if (obj == null)
            _throwNPE();

        this.value = obj;*/
    }


    // static methods

    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    @static fun *.empty (): LSLOptional
    {
        result = _makeEmpty();
    }


    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    @static fun *.of (obj: Object): LSLOptional
    {
        requires obj != null;

        if (obj == null)
            _throwNPE();

        result = new OptionalAutomaton(state = Initialized,
            value = obj
        );
    }


    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    @static fun *.ofNullable (obj: Object): LSLOptional
    {
        if (obj == null)
            result = _makeEmpty();
        else
            result = new OptionalAutomaton(state = Initialized,
                value = obj
            );
    }


    // methods

    @AnnotatedWith("java.lang.Override")
    fun *.equals (@target @Parameterized(["T"]) self: LSLOptional, other: Object): boolean
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
                val otherValue: Object = OptionalAutomaton(other).value;
                result = action OBJECT_EQUALS(this.value, otherValue);
            }
            else
            {
                result = false;
            }
        }
    }


    @ParameterizedResult(["T"])
    fun *.filter (@target @Parameterized(["T"]) self: LSLOptional,
                  @Parameterized(["? super T"]) predicate: Predicate): LSLOptional
    {
        requires predicate != null;

        if (predicate == null)
            _throwNPE();

        if (this.value == null)
        {
            result = self;
        }
        else
        {
            val sat: boolean = action CALL(predicate, [this.value]);

            if (sat)
                result = self;
            else
                result = _makeEmpty();
        }
    }


    @Parameterized(["U"])
    @ParameterizedResult(["U"])
    // #problem
    fun *.flatMap (@target @Parameterized(["T"]) self: LSLOptional,
                   @Parameterized(["? super T", "? extends LSLOptional<? extends U>"]) mapper: Function): LSLOptional
    {
        requires mapper != null;

        if (mapper == null)
            _throwNPE();

        if (this.value == null)
        {
            result = _makeEmpty();
        }
        else
        {
            // #problem: cast action return value to LSLOptional
            result = action CALL(mapper, [this.value]) as LSLOptional;

            if (result == null)
                _throwNPE();
        }
    }


    fun *.get (@target @Parameterized(["T"]) self: LSLOptional): Object
    {
        if (this.value == null)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @AnnotatedWith("java.lang.Override")
    fun *.hashCode (@target @Parameterized(["T"]) self: LSLOptional): int
    {
        result = action OBJECT_HASH_CODE(this.value);
    }


    fun *.ifPresent (@target @Parameterized(["T"]) self: LSLOptional,
                     @Parameterized(["? super T"]) consumer: Consumer): void
    {
        requires this.value == null || (this.value != null && consumer != null);

        if (this.value != null)
        {
            if (consumer == null)
                _throwNPE();

            action CALL(consumer, [this.value]);
        }
    }


    fun *.ifPresentOrElse (@target @Parameterized(["T"]) self: LSLOptional,
                           @Parameterized(["? super T"]) consumer: Consumer,
                           emptyAction: Runnable): void
    {
        requires this.value == null || (this.value != null && consumer != null);
        requires this.value != null || (this.value == null && emptyAction != null);

        if (this.value != null)
        {
            if (consumer == null)
                _throwNPE();

            action CALL(consumer, [this.value]);
        }
        else
        {
            if (emptyAction == null)
                _throwNPE();

            action CALL(emptyAction, []);
        }
    }


    fun *.isEmpty (@target @Parameterized(["T"]) self: LSLOptional): boolean
    {
        result = this.value == null;
    }


    fun *.isPresent (@target @Parameterized(["T"]) self: LSLOptional): boolean
    {
        result = this.value != null;
    }


    @Parameterized(["U"])
    @ParameterizedResult(["U"])
    fun *.map (@target @Parameterized(["T"]) self: LSLOptional,
               @Parameterized(["? super T", "? extends U"]) mapper: Function): LSLOptional
    {
        requires mapper != null;

        if (mapper == null)
            _throwNPE();

        if (this.value == null)
        {
            result = _makeEmpty();
        }
        else
        {
            // #problem: where is type U ?
            val mappedValue: Object = action CALL(mapper, [this.value]);

            if (mappedValue == null)
                result = _makeEmpty();
            else
                // #problem: how to parameterize the result?
                result = new OptionalAutomaton(state = Initialized,
                    value = mappedValue
                );
        }
    }


    @ParameterizedResult(["T"])
    fun *.or (@target @Parameterized(["T"]) self: LSLOptional,
              @Parameterized(["? extends LSLOptional<? extends T>"]) supplier: Supplier): LSLOptional
    {
        requires supplier != null;

        if (supplier == null)
            _throwNPE();

        if (this.value == null)
        {
            result = action CALL(supplier, []) as LSLOptional;

            if (result == null)
                _throwNPE();
        }
        else
        {
            result = self;
        }
    }


    fun *.orElse (@target @Parameterized(["T"]) self: LSLOptional, other: Object): Object
    {
        if (this.value == null)
            result = other;
        else
            result = this.value;
    }


    fun *.orElseGet (@target @Parameterized(["T"]) self: LSLOptional,
                     @Parameterized(["? extends T"]) supplier: Supplier): Object
    {
        requires supplier != null;

        if (supplier == null)
            _throwNPE();

        if (this.value == null)
            result = action CALL(supplier, []);
        else
            result = this.value;
    }


    fun *.orElseThrow (@target @Parameterized(["T"]) self: LSLOptional): Object
    {
        requires this.value != null;

        if (this.value == null)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["java.lang.Throwable"])
    fun *.orElseThrow (@target @Parameterized(["T"]) self: LSLOptional,
                       @Parameterized(["? extends X"]) exceptionSupplier: Supplier): Object
    {
        requires exceptionSupplier != null;

        if (exceptionSupplier == null)
            _throwNPE();

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
    fun *.stream (@target @Parameterized(["T"]) self: LSLOptional): Stream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    @AnnotatedWith("java.lang.Override")
    fun *.toString (@target @Parameterized(["T"]) self: LSLOptional): String
    {
        if (this.value == null)
        {
            result = "Optional.empty";
        }
        else
        {
            val valueStr: String = action OBJECT_TO_STRING(this.value);
            result = "Optional[" + valueStr + "]";
        }
    }

}
