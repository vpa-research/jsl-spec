libsl "1.1.0";


// language-specific aspects


annotation Static ();

annotation Final ();

annotation Transient ();

annotation Private ();

annotation PackagePrivate ();

annotation Public ();

annotation Extends (
    fullClassName: string;
);

annotation Implements (
    fullInterfaceNames: array<string>;
);

annotation Throws (
    exceptionTypes: array<string> = [];
);


// generator-specific aspects


annotation Deprecated ();

annotation NoReturn ();

annotation StopsControlFlow ();

annotation TypeMapping (
    fullClassName: string = null;
    builtin: bool = false;
);

annotation From (
    parentAutomatonName: string;
);

annotation WrapperMeta (
    src: string;
    dst: string;
    forceMatchInterfaces: bool = false;
);

