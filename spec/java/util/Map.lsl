//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Map.java";

// imports

import java/lang/Object;
import java/util/Set;
import java/io/Serializable;


// primary semantic types

@Parameterized(["K", "V"])
@interface type Map
    is java.util.Map
    for Object
{
    fun *.size(): int;

    fun *.isEmpty(): boolean;

    fun *.containsKey(key: Object): boolean;

    fun *.containsValue(value: Object): boolean;

    fun *.get(key: Object): Object;

    fun *.put(key: Object, value: Object): Object;

    fun *.remove(key: Object): Object;

    fun *.remove(key: Object, value: Object): boolean;

    fun *.clear(): void;

    fun *.entrySet(): Set;
}

@Parameterized(["K", "V"])
@interface type Map_Entry
    is java.util.Map.Entry
    for Object
{
    fun *.getKey(): Object;

    fun *.getValue(): Object;

    fun *.setValue(value: Object): Object;
}


// global aliases and type overrides


@GenerateMe
@implements("java.io.Serializable")
@public type SimpleEntry
    is java.util.SimpleEntry
    for Map_Entry
{
    @private @static val serialVersionUID: long = -8499721149061103585L;
}