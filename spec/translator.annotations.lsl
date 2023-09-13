//#! pragma: non-synthesizable
libsl "1.1.0";

// TODO: remove debug code
library any
    version "*"
    language "*"
    url "-";


/// generator-specific aspects


// Adds an annotation to on specified element in the output code
annotation AnnotatedWith (
    annotationTypeName: string,
    annotationParameters: array<any> = [],
);


// Forces the body of a specified subroutine to be copy-pasted at the callsite.
annotation AutoInline ();


// The marked feature is no longer needed or required.
annotation Deprecated (
    note: string = "",
    forRemoval: bool = false,
);


// The declared type have no direct connection any of the existing JSL classes,
// thus requiring the creation of a completely new one.
annotation GenerateMe ();


// Indicates that a subroutine should be accessible to other automata.
annotation KeepVisible ();


// The merked method does not return to normal execution.
annotation NoReturn ();


// <unused>
annotation Parameterized (
    typeParameters: array<string>,
);

// <unused>
annotation ParameterizedResult (
    typeParameters: array<string>,
);


// disables code generation for subroutine and uses its body as an element for loop or other structure
// should be used only on subroutines
annotation Phantom ();


// The marked action stops execution of current control flow by throwing exception or other means.
annotation StopsControlFlow ();


// <unused>
// Associates the type on the LEFT side of typealias with the specified type.
//@Deprecated
annotation TypeMapping (
    fullClassName: string = null,
    builtin: bool = false,
    typeVariable: bool = false, // unused
);
