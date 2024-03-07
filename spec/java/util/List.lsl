libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/List.java";

// imports

import java/util/Collection;


// primary semantic types

@Parameterized(["E"])
@interface type List
    is java.util.List
    for Collection
{
}


// global aliases and type overrides

@implements("java.util.List")
@public @interface type LSLList
    is java.util.List
    for List
{
}
