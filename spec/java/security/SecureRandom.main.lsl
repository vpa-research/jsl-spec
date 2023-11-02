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
    var secureRandomSpi: SecureRandomSpi;
    var provider: Provider;
    var algorithm: String;
    var threadSafe: boolean;

    // utilities

    proc _getDefaultPRNG (setSeed: boolean, seed: array<byte>): void
    {
        val providersList: array<Provider> = action DEBUG_DO("java.security.Security.getProviders()");
        val providersListLength: int = action ARRAY_SIZE(providersList);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findProvider_loop(i, providersList)
        );

        action ASSUME(this.provider != null);
        action ASSUME(this.algorithm != null);

        // #draft_below (maybe it will be deleted)

        // val firstProviderName: String = action DEBUG_DO("providersList[0].getName()");
        // action ASSUME(action OBJECT_EQUALS("firstProviderName", "SUN"));
        // val services: Set = action DEBUG_DO("providersList[0].getServices()");

        // #note: this is list of default algorithms https://docs.oracle.com/en/java/javase/11/docs/specs/security/standard-names.html#securerandom-number-generation-algorithms
        /* if (action CALL_METHOD(services, "contains", ["NativePRNGNonBlocking"]))
        {
            // todo: it can throws AssertionError
            this.secureRandomSpi = action DEBUG_DO("new sun.security.provider.NativePRNG.NonBlocking()");
        }
        else if (action CALL_METHOD(services, "contains", ["NativePRNGBlocking"]))
        {
            // todo: it can throws AssertionError
            this.secureRandomSpi = action DEBUG_DO("new sun.security.provider.NativePRNG.Blocking()");
        }
        else if (action CALL_METHOD(services, "contains", ["NativePRNG"]))
        {
            // todo: it can throws AssertionError
            this.secureRandomSpi = action DEBUG_DO("new sun.security.provider.NativePRNG()");
        }
        else if (action CALL_METHOD(services, "contains", ["Windows-PRNG"]))
        {

        }
        else if (action CALL_METHOD(services, "contains", ["SHA1PRNG"]))
        {
            // todo: it has reflection calls inside; That's why must be created automaton ! And constructor must be approximated;
            this.secureRandomSpi = action DEBUG_DO("new sun.security.provider.SecureRandom()");
        }
        else if (action CALL_METHOD(services, "contains", ["DRBG"]))
        {
            this.secureRandomSpi = action DEBUG_DO("new sun.security.provider.NativePRNG()");
        }
        else if (action CALL_METHOD(services, "contains", ["PKCS11"]))
        {

        }*/
    }


    @Phantom proc findProvider_loop (i: int, providersList: array<Provider>): void
    {
        val curProvider: Provider = providersList[i];
        val services: Set = action DEBUG_DO("curProvider.getServices()");
        val servicesLength: int = action CALL_METHOD(services, "size", []);

        var j: int = 0;
        action LOOP_FOR(
            j, 0, providersListLength, +1,
            findService_loop(j, services, curProvider)
        );
    }


    @Phantom proc findService_loop (j: int, services: Set, curProvider: Provider): void
    {
        val curService: Service = action DEBUG_DO("services[j].getServices()");
        val curServiceType: String = action DEBUG_DO("curService.getType()");

        if (action OBJECT_EQUALS(curServiceType, "SecureRandom"))
        {
            this.provider = curProvider;
            this.algorithm = action DEBUG_DO("curService.getAlgorithm()");
            action LOOP_BREAK();
        }
    }


    proc _setSeed(): void
    {
        // TODO()
    }


    // constructors

    constructor *.SecureRandom (@target self: SecureRandom)
    {
        _setSeed();
        _getDefaultPRNG(false, null);
        val arg0: String = "SecureRandom.SHA1PRNG ThreadSafe";
        val arg1: String = "false";
        this.threadSafe = action DEBUG_DO("Boolean.parseBoolean(provider.getProperty(arg0, arg1))");
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