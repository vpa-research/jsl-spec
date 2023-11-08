libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/security/SecureRandom.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/security/Security;
import java/security/SecureRandom;
import java/security/Provider;
import java/security/Service;
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

    var provider: Provider;
    var algorithm: String;
    var defaultProvider: boolean = false;


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwIAE (): void
    {
        action THROW_NEW("java.lang.IllegalArgumentException", []);
    }


    @AutoInline @Phantom proc _throwIE (): void
    {
        action THROW_NEW("java.lang.InternalError", []);
    }


    proc _getDefaultPRNG (setSeed: boolean, seed: array<byte>): void
    {
        val providersList: array<Provider> = action CALL_METHOD(null as Security, "getProviders", [])
        val providersListLength: int = action ARRAY_SIZE(providersList);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findProvider_loop(i, providersList)
        );

        if (this.provider == null || this.algorithm == null)
            _throwIE();

        _isDefaultProvider();
    }


    @Phantom proc findProvider_loop (i: int, providersList: array<Provider>): void
    {
        val curProvider: Provider = providersList[i];
        val services: Set = action CALL_METHOD(curProvider, "getServices", []);
        val iter: Iterator = action CALL_METHOD(services, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            findService_loop(iter, curProvider)
        );
    }


    @Phantom proc findService_loop (iter: Iterator, curProvider: Provider): void
    {
        val curService: Provider_Service = action CALL_METHOD(iter, "next", []) as Provider_Service;
        val curServiceType: String = action CALL_METHOD(curService, "getType", []);

        if (action OBJECT_EQUALS(curServiceType, "SecureRandom"))
        {
            this.provider = curProvider;
            this.algorithm = action CALL_METHOD(curService, "getAlgorithm", []);
            action LOOP_BREAK();
        }
    }


    proc _isDefaultProvider (): void
    {
        val providerName: String = action CALL_METHOD(this.provider, "getName", []);

        if (action MAP_HAS_KEY(this.defaultProvidersMap, providerName))
            this.defaultProvider = true;
    }


    @Phantom proc _nextBytes (bytes: array<byte>): void
    {
        // #question: is there a more efficient way?
        val size: int = action ARRAY_SIZE(bytes);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            nextBytes_loop(i, bytes)
        );
    }


    @Phantom proc _generateSeed (result: array<byte>, numBytes: int): void
    {
        // #question: is there a more efficient way?
        val size: int = numBytes;
        var bytes: array<byte> = action ARRAY_NEW("byte", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            nextBytes_loop(i, bytes)
        );
        result = bytes;
    }


    // special: static initialization


    @Phantom @static fun *.__clinit__ (): void
    {
        // #note: list of default providers https://docs.oracle.com/javase/9/security/oracleproviders.htm#JSSEC-GUID-F41EE1C9-DD6A-4BAB-8979-EB7654094029

        action MAP_SET(defaultProvidersMap, "SUN", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunRsaSign", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunJSSE", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunJCE", SOMETHING);
        action MAP_SET(defaultProvidersMap, "Apple", SOMETHING);

        action MAP_SET(defaultProvidersMap, "JdkLDAP", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunJGSS", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunSASL", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunPCSC", SOMETHING);
        action MAP_SET(defaultProvidersMap, "XMLDSig", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunPKCS11", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunEC", SOMETHING);
        action MAP_SET(defaultProvidersMap, "SunMSCAPI", SOMETHING);
        action MAP_SET(defaultProvidersMap, "OracleUcrypto", SOMETHING);
        action MAP_SET(defaultProvidersMap, "JdkSASL", SOMETHING);
    }


    // constructors

    constructor *.SecureRandom (@target self: SecureRandom)
    {
        _getDefaultPRNG(false, null);
    }


    // #question: do we need such realization of constructor ? Or it must be empty because this is "protected" ?
    @protected constructor *.SecureRandom (@target self: SecureRandom, secureRandomSpi: SecureRandomSpi, provider: Provider)
    {
        action ERROR("Protected constructor call");
    }


    // #question: do we need such realization of constructor ? Or it must be empty because this is "private" ?
    @private constructor *.SecureRandom (@target self: SecureRandom, secureRandomSpi: SecureRandomSpi, provider: Provider, algorithm: String)
    {
        action ERROR("Private constructor call");
    }


    constructor *.SecureRandom (@target self: SecureRandom, seed: array<byte>)
    {
        _getDefaultPRNG(false, null);
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
        if (numBytes < 0)
            _throwIAE();

        action SYNCHRONIZED_BLOCK(self, _generateSeed(result, numBytes));
    }


    fun *.getAlgorithm (@target self: SecureRandom): String
    {
        result = this.algorithm;
    }


    fun *.getParameters (@target self: SecureRandom): SecureRandomParameters
    {
        action TODO();
    }


    @final fun *.getProvider (@target self: SecureRandom): Provider
    {
        result = this.provider;
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
        result = action SYMBOLIC("boolean");
    }


    fun *.nextBytes (@target self: SecureRandom, bytes: array<byte>): void
    {
        action SYNCHRONIZED_BLOCK(self, _nextBytes(bytes));
    }


    @Phantom proc nextBytes_loop (i: int, bytes: array<byte>): void
    {
        bytes[i] = action SYMBOLIC("byte");
    }


    fun *.nextBytes (@target self: SecureRandom, bytes: array<byte>, params: SecureRandomParameters): void
    {
        if (params == null)
            _throwIAE();

        if (bytes == null)
            _throwNPE();

        action SYNCHRONIZED_BLOCK(self, _nextBytes(bytes));
    }


    // within java.util.Random
    fun *.nextDouble (@target self: SecureRandom): double
    {
        result = action SYMBOLIC("double");

        action ASSUME(0.0 <= result);
        action ASSUME(result < 1.0);
    }


    // within java.util.Random
    fun *.nextFloat (@target self: SecureRandom): float
    {
        result = action SYMBOLIC("float");

        action ASSUME(0.0f <= result);
        action ASSUME(result < 1.0f);
    }


    // within java.util.Random
    @synchronized fun *.nextGaussian (@target self: SecureRandom): double
    {
        result = action SYMBOLIC("double");
        val isNaN: boolean = action DEBUG_DO("Double.isNaN(result)");
        action ASSUME(isNaN == false);
    }


    // within java.util.Random
    fun *.nextInt (@target self: SecureRandom): int
    {
        result = action SYMBOLIC("int");
    }


    // within java.util.Random
    fun *.nextInt (@target self: SecureRandom, bound: int): int
    {
        if (bound <= 0)
            action THROW_NEW("java.lang.IllegalArgumentException", ["bound must be positive"]);

        result = action SYMBOLIC("int");

        action ASSUME(0 <= result);
        action ASSUME(result < bound);
    }


    // within java.util.Random
    fun *.nextLong (@target self: SecureRandom): long
    {
        result = action SYMBOLIC("long");
    }


    fun *.reseed (@target self: SecureRandom): void
    {
        action DO_NOTHING();
    }


    fun *.reseed (@target self: SecureRandom, params: SecureRandomParameters): void
    {
        if (params == null)
            _throwIAE();

        action DO_NOTHING();
    }


    fun *.setSeed (@target self: SecureRandom, seed: array<byte>): void
    {
        action DO_NOTHING();
    }


    fun *.setSeed (@target self: SecureRandom, seed: long): void
    {
        action DO_NOTHING();
    }


    fun *.toString (@target self: SecureRandom): String
    {
        action TODO();
    }

}