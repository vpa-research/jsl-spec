//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

import java.common;


@TypeMapping("java.util.function.BiConsumer")
typealias BiConsumer = Object;    // #problem

@TypeMapping("java.util.function.BiFunction")
typealias BiFunction = Object;    // #problem

@TypeMapping("java.util.function.BinaryOperator")
typealias BinaryOperator = Object;    // #problem

@TypeMapping("java.util.function.BiPredicate")
typealias BiPredicate = Object;    // #problem

@TypeMapping("java.util.function.BooleanSupplier")
typealias BooleanSupplier = Object;    // #problem


// #problem: type parameter?
@Parameterized(["T"])
type Consumer is java.util.function.Consumer for Object {
    fun accept(x: Object): void;
}


@TypeMapping("java.util.function.DoubleBinaryOperator")
typealias DoubleBinaryOperator = Object;    // #problem


type DoubleConsumer is java.util.function.DoubleConsumer for Object {
    fun accept(x: double): void;
}


@TypeMapping("java.util.function.DoubleFunction")
typealias DoubleFunction = Object;    // #problem


type DoublePredicate is java.util.function.DoublePredicate for Object {
    fun test(t: double): boolean;
}


type DoubleSupplier is java.util.function.DoubleSupplier for Object {
    fun get(): double;
}


@TypeMapping("java.util.function.DoubleToIntFunction")
typealias DoubleToIntFunction = Object;    // #problem

@TypeMapping("java.util.function.DoubleToLongFunction")
typealias DoubleToLongFunction = Object;    // #problem

@TypeMapping("java.util.function.DoubleUnaryOperator")
typealias DoubleUnaryOperator = Object;    // #problem


// #problem: type parameters?
type Function is java.util.function.Function for Object {
    fun apply(o: Object): Object;
}


@TypeMapping("java.util.function.IntBinaryOperator")
typealias IntBinaryOperator = Object;    // #problem


type IntConsumer is java.util.function.IntConsumer for Object {
    fun accept(x: int): void;
}


@TypeMapping("java.util.function.IntFunction")
typealias IntFunction = Object;    // #problem


type IntPredicate is java.util.function.IntPredicate for Object {
    fun test(t: int): boolean;
}


type IntSupplier is java.util.function.IntSupplier for Object {
    fun get(): int;
}


@TypeMapping("java.util.function.IntToDoubleFunction")
typealias IntToDoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.IntToLongFunction")
typealias IntToLongFunction = Object;    // #problem

@TypeMapping("java.util.function.IntUnaryOperator")
typealias IntUnaryOperator = Object;    // #problem

@TypeMapping("java.util.function.LongBinaryOperator")
typealias LongBinaryOperator = Object;    // #problem


type LongConsumer is java.util.function.LongConsumer for Object {
    fun accept(x: long): void;
}


@TypeMapping("java.util.function.LongFunction")
typealias LongFunction = Object;    // #problem


type LongPredicate is java.util.function.LongPredicate for Object {
    fun test(t: long): boolean;
}


type LongSupplier is java.util.function.LongSupplier for Object {
    fun get(): long;
}


@TypeMapping("java.util.function.LongToDoubleFunction")
typealias LongToDoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.LongToIntFunction")
typealias LongToIntFunction = Object;    // #problem

@TypeMapping("java.util.function.LongUnaryOperator")
typealias LongUnaryOperator = Object;    // #problem

@TypeMapping("java.util.function.ObjDoubleConsumer")
typealias ObjDoubleConsumer = Object;    // #problem

@TypeMapping("java.util.function.ObjIntConsumer")
typealias ObjIntConsumer = Object;    // #problem

@TypeMapping("java.util.function.ObjLongConsumer")
typealias ObjLongConsumer = Object;    // #problem


// #problem: type parameter?
type Predicate is java.util.function.Predicate for Object {
    // #problem: type parameter?
    fun test(t: Object): boolean;
}


// #problem: type parameter?
@Parameterized(["T"])
type Supplier is java.util.function.Supplier for Object {
    fun get(): Object;
}


@TypeMapping("java.util.function.ToDoubleBiFunction")
typealias ToDoubleBiFunction = Object;    // #problem

@TypeMapping("java.util.function.ToDoubleFunction")
typealias ToDoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.ToIntBiFunction")
typealias ToIntBiFunction = Object;    // #problem

@TypeMapping("java.util.function.ToIntFunction")
typealias ToIntFunction = Object;    // #problem

@TypeMapping("java.util.function.ToLongBiFunction")
typealias ToLongBiFunction = Object;    // #problem

@TypeMapping("java.util.function.ToLongFunction")
typealias ToLongFunction = Object;    // #problem

@TypeMapping("java.util.function.UnaryOperator")
typealias UnaryOperator = Object;    // #problem
