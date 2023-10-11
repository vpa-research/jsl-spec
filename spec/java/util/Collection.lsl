//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Collection.java";

// imports

import java/lang/Iterable;
import java/lang/Object;
import java/util/Iterator;


// primary semantic types

@Parameterized(["E"])
@interface type Collection
    is java.util.Collection
    for Iterable
{
    fun *.size(): int;

    fun *.isEmpty(): boolean;

    fun *.contains(o: Object): boolean;

    @ParameterizedResult(["E"])
    fun *.iterator(): Iterator;

    fun *.toArray(): array<Object>;

    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    fun *.toArray(@Parameterized(["T"]) a: array<Object>): array<Object>;

    /*
    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    fun *.toArray(@Parameterized(["T[]"]) generator: IntFunction): array<Object>;
    */

    fun *.add(e: Object): boolean;

    fun *.remove(o: Object): boolean;

    // #problem
    //fun *.containsAll(@Parameterized(["?"]) c: Collection): boolean;

    // #problem
    //fun *.addAll(@Parameterized(["? extends E"]) c: Collection): boolean;

    // #problem
    //fun *.removeAll(@Parameterized(["?"]) c: Collection): boolean;

    //fun *.removeIf(@Parameterized(["? super E"]) filter: Predicate): boolean;

    // #problem
    //fun *.retainAll(@Parameterized(["?"]) c: Collection): boolean;

    fun *.clear(): void;

    // #problem: cannot use Stream here
}


// global aliases and type overrides

