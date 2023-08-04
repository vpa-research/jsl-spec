//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/lang";

// imports

import java.common;


// boxed built-in types

type Boolean is java.lang.Boolean for Object, bool {}

type Byte    is java.lang.Byte    for Object, int8,  unsigned8  {}
type Short   is java.lang.Short   for Object, int16, unsigned16 {}
type Integer is java.lang.Integer for Object, int32, unsigned32 {}
type Long    is java.lang.Long    for Object, int64, unsigned64 {}

type Float  is java.lang.Float  for Object, float32 {}
type Double is java.lang.Double for Object, float64 {}


type CharSequence
    is java.lang.CharSequence
    for Object
{
    fun length(): int;

    fun charAt(index: int): char;

    fun toString(): string; // #problem: using forward-declared type
}

type Character is java.lang.Character for Object, char {}
type String    is java.lang.String    for CharSequence, string {}


// general interfaces


type Runnable
    is java.lang.Runnable
    for Object
{
    fun run(): void;
}


type Throwable
    is java.lang.Throwable
    for Object
{
}


@Parameterized(["T"])
type Iterable
    is java.lang.Iterable
    for Object
{
}



// !!! temporary definitions

type StringBuffer is java.lang.StringBuffer for Object {}
type StringBuilder is java.lang.StringBuilder for Object {}
