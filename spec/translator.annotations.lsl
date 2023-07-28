//#! pragma: non-synthesizable
libsl "1.1.0";

// TODO: remove debug code
library any
    version "*"
    language "Java"
    url "-";


/// generator-specific aspects


// Adds an annotation to on specified element in the output code
annotation AnnotatedWith (
    annotationTypeName: string,
    annotationParameters: array<any> = [],
);


// Forces the body of a specified subroutine to be copy-pasted at the callsite.
annotation AutoInline;


// Stores the result of a function computation as a private field inside of the generated class.
// Something like: `private Set __cached_keySet = null;`
annotation CacheOnce;


// Stores the result of a function computation as a private static field inside of the generated class.
// Something like: `private static Set __cached_keySet = null;`
annotation CacheStaticOnce;


// The marked feature is no longer needed or required.
annotation Deprecated (
    hint: string = "",
    forRemoval: bool = false,
);


// Specifies expected parent automaton and a class-container.
annotation From (
    parentAutomatonName: string,
);


// The merked method does not return to normal execution.
annotation NoReturn;


// #problem
annotation Parameterized (
    typeParameters: array<string>,
);


// #problem
annotation ParameterizedResult (
    typeParameters: array<string>,
);


// The marked action stops execution of current control flow by throwing exception or other means.
annotation StopsControlFlow;


// Associates the type on the LEFT side of typealias with the specified type.
//@Deprecated
annotation TypeMapping (
    fullClassName: string = null,
    builtin: bool = false,
    typeVariable: bool = false, // #problem
);
