//#! pragma: non-synthesizable
libsl "1.1.0";

library `std`
    version "11"
    language "Java"
    url "-";

// imports

import java.common;


// semantic types

@Parameterized(["T", "U"]) // #problem
type BiConsumer
    is java.util.function.BiConsumer
    for Object
{
    fun accept(t: Object, u: Object): void;
}


@Parameterized(["T", "U", "R"]) // #problem
type BiFunction
    is java.util.function.BiFunction
    for Object
{
    fun apply(t: Object, u: Object): Object;
}


@Parameterized(["T"]) // #problem
type BinaryOperator
    is java.util.function.BinaryOperator
    for BiFunction, Object
{
    fun apply(ta: Object, tb: Object): Object;
}


@Parameterized(["T", "U"]) // #problem
type BiPredicate
    is java.util.function.BiPredicate
    for Object
{
    fun test(t: Object, u: Object): boolean;
}


type BooleanSupplier
    is java.util.function.BooleanSupplier
    for Object
{
    fun getAsBoolean(): boolean;
}


@Parameterized(["T"]) // #problem
type Consumer
    is java.util.function.Consumer
    for Object
{
    fun accept(t: Object): void;
}


type DoubleBinaryOperator
    is java.util.function.DoubleBinaryOperator
    for Object
{
    fun applyAsDouble(left: double, right: double): double;
}


type DoubleConsumer
    is java.util.function.DoubleConsumer
    for Object
{
    fun accept(value: double): void;
}


@Parameterized(["R"]) // #problem
type DoubleFunction
    is java.util.function.DoubleFunction
    for Object
{
    fun apply(value: double): Object;
}


type DoublePredicate
    is java.util.function.DoublePredicate
    for Object
{
    fun test(t: double): boolean;
}


type DoubleSupplier
    is java.util.function.DoubleSupplier
    for Object
{
    fun getAsDouble(): double;
}


type DoubleToIntFunction
    is java.util.function.DoubleToIntFunction
    for Object
{
    fun applyAsInt(value: double): int;
}


type DoubleToLongFunction
    is java.util.function.DoubleToLongFunction
    for Object
{
    fun applyAsLong(value: double): long;
}


type DoubleUnaryOperator
    is java.util.function.DoubleUnaryOperator
    for Object
{
    fun applyAsDouble(operand: double): double;
}


@Parameterized(["T", "R"]) // #problem
type Function
    is java.util.function.Function
    for Object
{
    fun apply(t: Object): Object;
}


type IntBinaryOperator
    is java.util.function.IntBinaryOperator
    for Object
{
    fun applyAsInt(left: int, right: int): int;
}


type IntConsumer
    is java.util.function.IntConsumer
    for Object
{
    fun accept(value: int): void;
}


@Parameterized(["R"]) // #problem
type IntFunction
    is java.util.function.IntFunction
    for Object
{
    fun apply(value: int): Object;
}


type IntPredicate
    is java.util.function.IntPredicate
    for Object
{
    fun test(value: int): boolean;
}


type IntSupplier
    is java.util.function.IntSupplier
    for Object
{
    fun getAsInt(): int;
}


type IntToDoubleFunction
    is java.util.function.IntToDoubleFunction
    for Object
{
    fun applyAsDouble(value: int): double;
}


type IntToLongFunction
    is java.util.function.IntToLongFunction
    for Object
{
    fun applyAsLong(value: int): long;
}


type IntUnaryOperator
    is java.util.function.IntUnaryOperator
    for Object
{
    fun applyAsInt(operand: int): int;
}


type LongBinaryOperator
    is java.util.function.LongBinaryOperator
    for Object
{
    fun applyAsLong(left: long, right: long): long;
}


type LongConsumer
    is java.util.function.LongConsumer
    for Object
{
    fun accept(value: long): void;
}


@Parameterized(["R"]) // #problem
type LongFunction
    is java.util.function.LongFunction
    for Object
{
    fun apply(value: long): Object;
}


type LongPredicate
    is java.util.function.LongPredicate
    for Object
{
    fun test(value: long): boolean;
}


type LongSupplier
    is java.util.function.LongSupplier
    for Object
{
    fun getAsLong(): long;
}


type LongToDoubleFunction
    is java.util.function.LongToDoubleFunction
    for Object
{
    fun applyAsDouble(value: long): double;
}


type LongToIntFunction
    is java.util.function.LongToIntFunction
    for Object
{
    fun applyAsInt(value: long): int;
}


type LongUnaryOperator
    is java.util.function.LongUnaryOperator
    for Object
{
    fun applyAsLong(operand: long): long;
}


@Parameterized(["T"]) // #problem
type ObjDoubleConsumer
    is java.util.function.ObjDoubleConsumer
    for Object
{
    fun accept(t: Object, value: double): void;
}


@Parameterized(["T"]) // #problem
type ObjIntConsumer
    is java.util.function.ObjIntConsumer
    for Object
{
    fun accept(t: Object, value: int): void;
}


@Parameterized(["T"]) // #problem
type ObjLongConsumer
    is java.util.function.ObjLongConsumer
    for Object
{
    fun accept(t: Object, value: long): void;
}


@Parameterized(["T"]) // #problem
type Predicate
    is java.util.function.Predicate
    for Object
{
    fun test(t: Object): boolean;
}


@Parameterized(["T"]) // #problem
type Supplier
    is java.util.function.Supplier
    for Object
{
    fun get(): Object;
}


@Parameterized(["T", "U"]) // #problem
type ToDoubleBiFunction
    is java.util.function.ToDoubleBiFunction
    for Object
{
    fun applyAsDouble(t: Object, u: Object): double;
}


@Parameterized(["T"]) // #problem
type ToDoubleFunction
    is java.util.function.ToDoubleFunction
    for Object
{
    fun applyAsDouble(t: Object): double;
}


@Parameterized(["T", "U"]) // #problem
type ToIntBiFunction
    is java.util.function.ToIntBiFunction
    for Object
{
    fun applyAsInt(t: Object, u: Object): int;
}


@Parameterized(["T"]) // #problem
type ToIntFunction
    is java.util.function.ToIntFunction
    for Object
{
    fun applyAsInt(t: Object): int;
}


@Parameterized(["T", "U"]) // #problem
type ToLongBiFunction
    is java.util.function.ToLongBiFunction
    for Object
{
    fun applyAsLong(t: Object, u: Object): long;
}


@Parameterized(["T"]) // #problem
type ToLongFunction
    is java.util.function.ToLongFunction
    for Object
{
    fun applyAsLong(value: Object): long;
}


@Parameterized(["T"]) // #problem
type UnaryOperator
    is java.util.function.UnaryOperator
    for Function, Object
{
    fun apply(t: Object): Object;
}
