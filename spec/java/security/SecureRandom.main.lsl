libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/SecureRandom.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/security/SecureRandom;
import java/security/Provider;
import java/security/SecureRandomParameters;
import java/security/SecureRandomSpi;
import java/util/Random;
import java/util/stream/DoubleStream;
import java/util/stream/IntStream;
import java/util/stream/LongStream;


// automata

automaton SecureRandomAutomaton
(
)
: SecureRandom
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        SecureRandom (SecureRandom),
        SecureRandom (SecureRandom, SecureRandomSpi, Provider),
        SecureRandom (SecureRandom, SecureRandomSpi, Provider, String),
        SecureRandom (SecureRandom, array<byte>),
        // static operations
        getInstance (String),
        getInstance (String, Provider),
        getInstance (String, SecureRandomParameters),
        getInstance (String, SecureRandomParameters, Provider),
        getInstance (String, SecureRandomParameters, String),
        getInstance (String, String),
        getInstanceStrong,
        getSeed,
    ];

    shift Initialized -> self by [
        // instance methods
        doubles (SecureRandom),
        doubles (SecureRandom, double, double),
        doubles (SecureRandom, long),
        doubles (SecureRandom, long, double, double),
        generateSeed,
        getAlgorithm,
        getParameters,
        getProvider,
        ints (SecureRandom),
        ints (SecureRandom, int, int),
        ints (SecureRandom, long),
        ints (SecureRandom, long, int, int),
        longs (SecureRandom),
        longs (SecureRandom, long),
        longs (SecureRandom, long, long),
        longs (SecureRandom, long, long, long),
        nextBoolean,
        nextBytes (SecureRandom, array<byte>),
        nextBytes (SecureRandom, array<byte>, SecureRandomParameters),
        nextDouble,
        nextFloat,
        nextGaussian,
        nextInt (SecureRandom),
        nextInt (SecureRandom, int),
        nextLong,
        reseed (SecureRandom),
        reseed (SecureRandom, SecureRandomParameters),
        setSeed (SecureRandom, array<byte>),
        setSeed (SecureRandom, long),
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.SecureRandom (@target self: SecureRandom)
    {
        action TODO();
    }


    @protected constructor *.SecureRandom (@target self: SecureRandom, secureRandomSpi: SecureRandomSpi, provider: Provider)
    {
        action TODO();
    }


    @private constructor *.SecureRandom (@target self: SecureRandom, secureRandomSpi: SecureRandomSpi, provider: Provider, algorithm: String)
    {
        action TODO();
    }


    constructor *.SecureRandom (@target self: SecureRandom, seed: array<byte>)
    {
        action TODO();
    }


    // static methods

    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (algorithm: String): SecureRandom
    {
        action TODO();
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (algorithm: String, provider: Provider): SecureRandom
    {
        action TODO();
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (algorithm: String, params: SecureRandomParameters): SecureRandom
    {
        action TODO();
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (algorithm: String, params: SecureRandomParameters, provider: Provider): SecureRandom
    {
        action TODO();
    }


    @throws(["java.security.NoSuchAlgorithmException", "java.security.NoSuchProviderException"])
    @static fun *.getInstance (algorithm: String, params: SecureRandomParameters, provider: String): SecureRandom
    {
        action TODO();
    }


    @throws(["java.security.NoSuchAlgorithmException", "java.security.NoSuchProviderException"])
    @static fun *.getInstance (algorithm: String, provider: String): SecureRandom
    {
        action TODO();
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstanceStrong (): SecureRandom
    {
        action TODO();
    }


    @static fun *.getSeed (numBytes: int): array<byte>
    {
        action TODO();
    }


    // methods

    // within java.util.Random
    fun *.doubles (@target self: SecureRandom): DoubleStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long): DoubleStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        action TODO();
    }


    fun *.generateSeed (@target self: SecureRandom, numBytes: int): array<byte>
    {
        action TODO();
    }


    fun *.getAlgorithm (@target self: SecureRandom): String
    {
        action TODO();
    }


    fun *.getParameters (@target self: SecureRandom): SecureRandomParameters
    {
        action TODO();
    }


    @final fun *.getProvider (@target self: SecureRandom): Provider
    {
        action TODO();
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom): IntStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long): IntStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom): LongStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long): LongStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        action TODO();
    }


    // within java.util.Random
    fun *.nextBoolean (@target self: SecureRandom): boolean
    {
        action TODO();
    }


    fun *.nextBytes (@target self: SecureRandom, bytes: array<byte>): void
    {
        action TODO();
    }


    fun *.nextBytes (@target self: SecureRandom, bytes: array<byte>, params: SecureRandomParameters): void
    {
        action TODO();
    }


    // within java.util.Random
    fun *.nextDouble (@target self: SecureRandom): double
    {
        action TODO();
    }


    // within java.util.Random
    fun *.nextFloat (@target self: SecureRandom): float
    {
        action TODO();
    }


    // within java.util.Random
    @synchronized fun *.nextGaussian (@target self: SecureRandom): double
    {
        action TODO();
    }


    // within java.util.Random
    fun *.nextInt (@target self: SecureRandom): int
    {
        action TODO();
    }


    // within java.util.Random
    fun *.nextInt (@target self: SecureRandom, bound: int): int
    {
        action TODO();
    }


    // within java.util.Random
    fun *.nextLong (@target self: SecureRandom): long
    {
        action TODO();
    }


    fun *.reseed (@target self: SecureRandom): void
    {
        action TODO();
    }


    fun *.reseed (@target self: SecureRandom, params: SecureRandomParameters): void
    {
        action TODO();
    }


    fun *.setSeed (@target self: SecureRandom, seed: array<byte>): void
    {
        action TODO();
    }


    fun *.setSeed (@target self: SecureRandom, seed: long): void
    {
        action TODO();
    }


    fun *.toString (@target self: SecureRandom): String
    {
        action TODO();
    }

}