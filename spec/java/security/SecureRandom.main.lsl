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
    var defaultProvider: boolean = false;

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

        _isDefaultProvider();
    }


    @Phantom proc findProvider_loop (i: int, providersList: array<Provider>): void
    {
        val curProvider: Provider = providersList[i];
        val services: Set = action DEBUG_DO("curProvider.getServices()");
        val servicesLength: int = action CALL_METHOD(services, "size", []);

        var j: int = 0;
        action LOOP_FOR(
            j, 0, servicesLength, +1,
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


    proc _isDefaultProvider(): void
    {
        val providerName: String = action DEBUG_DO("this.provider.getName()");

        // #note: list of default providers https://docs.oracle.com/en/java/javase/11/security/oracle-providers.html#GUID-F41EE1C9-DD6A-4BAB-8979-EB7654094029
        if (action OBJECT_EQUALS(providerName, "SUN"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunRsaSign"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunJSSE"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunJCE"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "Apple"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "JdkLDAP"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunJGSS"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunSASL"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunPCSC"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "XMLDSig"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunPKCS11"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunEC"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "SunMSCAPI"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "OracleUcrypto"))
        {
            this.defaultProvider = true;
        }
        else if (action OBJECT_EQUALS(providerName, "JdkSASL"))
        {
            this.defaultProvider = true;
        }
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