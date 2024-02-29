libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "-";

// imports

import java/io/InputStream;


// primary semantic types

@GenerateMe
@extends("java.io.InputStream")
@public @final type SymbolicInputStream
    is `libsl.utils.SymbolicInputStream`
    for InputStream
{
}
