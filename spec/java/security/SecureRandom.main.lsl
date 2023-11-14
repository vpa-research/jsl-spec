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
import java/security/SecureRandomSpi;
import java/util/Random;
import java/util/stream/DoubleStream;
import java/util/stream/IntStream;
import java/util/stream/LongStream;


// automata

automaton SecureRandomAutomaton
(
    var provider: Provider,
    var algorithm: String,
    var defaultProvider: boolean
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
        nextDouble,
        nextFloat,
        nextGaussian,
        nextInt (SecureRandom),
        nextInt (SecureRandom, int),
        nextLong,
        setSeed (SecureRandom, array<byte>),
        setSeed (SecureRandom, long),
    ];


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwIAE (): void
    {
        action THROW_NEW("java.lang.IllegalArgumentException", []);
    }


    @AutoInline @Phantom proc _throwNSAE (): void
    {
        action THROW_NEW("java.security.NoSuchAlgorithmException", []);
    }


    @AutoInline @Phantom proc _throwIE (): void
    {
        action THROW_NEW("java.lang.InternalError", []);
    }


    @AutoInline @Phantom proc _throwIAE (): void
    {
        action THROW_NEW("java.lang.IllegalArgumentException", []);
    }


    @AutoInline @Phantom proc _throwNSPE (): void
    {
        action THROW_NEW("java.security.NoSuchProviderException", []);
    }


    proc _getDefaultPRNG (setSeed: boolean, seed: array<byte>): void
    {
        val providersList: array<Provider> = action CALL_METHOD(null as Security, "getProviders", []);
        val providersListLength: int = action ARRAY_SIZE(providersList);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findProvider_loop(i, providersList)
        );

        if (this.provider == null || this.algorithm == null)
            _throwIE();

        this.defaultProvider = _isDefaultProvider(this.provider);
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


    @static proc _isDefaultProvider (curProvider: Provider): boolean
    {
        val providerName: String = action CALL_METHOD(curProvider, "getName", []);

        if (action MAP_HAS_KEY(this.defaultProvidersMap, providerName))
            result = true;
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


    proc _generateRandomIntegerArray (size: int): array<int>
    {
        result = action ARRAY_NEW("int", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            generateIntArray_loop(i, result)
        );
    }


    @Phantom proc generateIntArray_loop (i: int, result: array<int>): void
    {
        result[i] = action SYMBOLIC("int");
    }


    proc _generateRandomIntegerArrayWithBounds (size: int, randomNumberOrigin: int, randomNumberBound: int): array<int>
    {
        result = action ARRAY_NEW("int", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            generateIntArrayWithBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc generateIntArrayWithBounds_loop (i: int, result: array<int>, randomNumberOrigin: int, randomNumberBound: int): void
    {
        result[i] = action SYMBOLIC("int");
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomLongArray (size: int): array<long>
    {
        result = action ARRAY_NEW("long", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            generateLongArray_loop(i, result)
        );
    }


    @Phantom proc generateLongArray_loop (i: int, result: array<long>): void
    {
        result[i] = action SYMBOLIC("long");
    }


    proc _generateRandomLongArrayWithBounds (size: int, randomNumberOrigin: long, randomNumberBound: long): array<long>
    {
        result = action ARRAY_NEW("long", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            generateLongArrayWithBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc generateLongArrayWithBounds_loop (i: int, result: array<long>, randomNumberOrigin: long, randomNumberBound: long): void
    {
        result[i] = action SYMBOLIC("long");
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomDoubleArray (size: int): array<double>
    {
        result = action ARRAY_NEW("double", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            generateDoubleArray_loop(i, result)
        );
    }


    @Phantom proc generateDoubleArray_loop (i: int, result: array<double>): void
    {
        result[i] = action SYMBOLIC("double");
    }


    proc _generateRandomDoubleArrayWithBounds (size: int, randomNumberOrigin: double, randomNumberBound: double): array<double>
    {
        result = action ARRAY_NEW("double", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            generateDoubleArrayWithBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc generateDoubleArrayWithBounds_loop (i: int, result: array<double>, randomNumberOrigin: double, randomNumberBound: double): void
    {
        result[i] = action SYMBOLIC("double");
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
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
        val providersList: array<Provider> = action CALL_METHOD(null as Security, "getProviders", []);
        val providersListLength: int = action ARRAY_SIZE(providersList);
        var resultProvider: Provider = null;
        var resultAlgorithm: String = null;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findAlgorithmByAllProviders_loop(i, providersList, algorithm, resultProvider, resultAlgorithm)
        );

        if (resultAlgorithm == null)
            _throwNSAE();

        val isDefaultProvider: boolean = _isDefaultProvider(resultProvider);

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = isDefaultProvider,
        );
    }


    @Phantom proc findAlgorithmByAllProviders_loop (i: int, providersList: array<Provider>, algorithm: String, resultProvider: Provider, resultAlgorithm: String): void
    {
        val curProvider: Provider = providersList[i];
        val services: Set = action CALL_METHOD(curProvider, "getServices", []);
        val iter: Iterator = action CALL_METHOD(services, "iterator", []);
        resultProvider = curProvider;

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            findAlgorithm_loop(iter, curProvider, algorithm, resultAlgorithm)
        );
    }


    @Phantom proc findAlgorithm_loop (iter: Iterator, curProvider: Provider, algorithm: String, resultAlgorithm: String): void
    {
        val curService: Provider_Service = action CALL_METHOD(iter, "next", []) as Provider_Service;
        val curServiceType: String = action CALL_METHOD(curService, "getType", []);
        val curServiceAlgorithm: String = action CALL_METHOD(curService, "getAlgorithm", []);

        if (action OBJECT_EQUALS(curServiceType, "SecureRandom") && action OBJECT_EQUALS(curServiceAlgorithm, algorithm))
        {
            resultAlgorithm = curServiceAlgorithm;
            action LOOP_BREAK();
        }
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (algorithm: String, provider: Provider): SecureRandom
    {
        if (provider == null)
            _throwIAE();

        val providersListLength: int = 1;
        val providersList: array<Provider> = action ARRAY_NEW("java.security.Provider", providersListLength);
        providersList[0] = provider;
        var resultProvider: Provider = null;
        var resultAlgorithm: String = null;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findAlgorithmByAllProviders_loop(i, providersList, algorithm, resultProvider, resultAlgorithm)
        );

        if (resultAlgorithm == null)
            _throwNSAE();

        val isDefaultProvider: boolean = _isDefaultProvider(resultProvider);

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = isDefaultProvider,
        );
    }


    @throws(["java.security.NoSuchAlgorithmException", "java.security.NoSuchProviderException"])
    @static fun *.getInstance (algorithm: String, providerName: String): SecureRandom
    {
        if (providerName == null || action CALL_METHOD(providerName, "length", []) == 0)
            _throwIAE();

        val providersList: array<Provider> = action CALL_METHOD(null as Security, "getProviders", []);
        val providersListLength: int = action ARRAY_SIZE(providersList);
        var resultProvider: Provider = null;
        var resultAlgorithm: String = null;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findAlgorithmByAllProvidersByName_loop(i, providersList, algorithm, resultProvider, resultAlgorithm, providerName)
        );

        if (resultProvider == null)
            _throwNSPE();

        if (resultAlgorithm == null)
            _throwNSAE();

        val isDefaultProvider: boolean = _isDefaultProvider(resultProvider);

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = isDefaultProvider,
        );
    }


    @Phantom proc findAlgorithmByAllProvidersByName_loop (i: int, providersList: array<Provider>, algorithm: String, resultProvider: Provider, resultAlgorithm: String, providerName: String): void
    {
        val curProvider: Provider = providersList[i];
        val curProviderName: String = action CALL_METHOD(curProvider, "getName", []);
        if (action OBJECT_EQUALS(curProviderName, providerName))
        {
            val services: Set = action CALL_METHOD(curProvider, "getServices", []);
            val iter: Iterator = action CALL_METHOD(services, "iterator", []);
            resultProvider = curProvider;

            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                findAlgorithm_loop(iter, curProvider, algorithm, resultAlgorithm)
            );
        }
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstanceStrong (): SecureRandom
    {
        action TODO();
    }


    @static fun *.getSeed (numBytes: int): array<byte>
    {
        if (numBytes < 0)
            _throwIAE();

        _generateSeed(result, numBytes);
    }


    // methods

    // within java.util.Random
    fun *.doubles (@target self: SecureRandom): DoubleStream
    {
        val mass: array<double> = _generateRandomDoubleArray(MAX_RANDOM_STREAM_SIZE);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        val mass: array<double> = _generateRandomDoubleArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long): DoubleStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<double> = _generateRandomDoubleArray(size);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<double> = _generateRandomDoubleArrayWithBounds(size, randomNumberOrigin, randomNumberBound);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    fun *.generateSeed (@target self: SecureRandom, numBytes: int): array<byte>
    {
        if (numBytes < 0)
            _throwIAE();

        _generateSeed(result, numBytes);
    }


    fun *.getAlgorithm (@target self: SecureRandom): String
    {
        result = this.algorithm;
    }


    @final fun *.getProvider (@target self: SecureRandom): Provider
    {
        result = this.provider;
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom): IntStream
    {
        val mass: array<int> = _generateRandomIntegerArray(MAX_RANDOM_STREAM_SIZE);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        val mass: array<int> = _generateRandomIntegerArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long): IntStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<int> = _generateRandomIntegerArray(size);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<int> = _generateRandomIntegerArrayWithBounds(size, randomNumberOrigin, randomNumberBound);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom): LongStream
    {
        val mass: array<long> = _generateRandomLongArray(MAX_RANDOM_STREAM_SIZE);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long): LongStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<long> = _generateRandomLongArray(size);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        val mass: array<long> = _generateRandomLongArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<long> = _generateRandomLongArrayWithBounds(size, randomNumberOrigin, randomNumberBound);
        var emptyCloseHandlersList: list<Runnable> = action LIST_NEW();

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = emptyCloseHandlersList,
        );
    }


    // within java.util.Random
    fun *.nextBoolean (@target self: SecureRandom): boolean
    {
        result = action SYMBOLIC("boolean");
    }


    fun *.nextBytes (@target self: SecureRandom, bytes: array<byte>): void
    {
        _nextBytes(bytes);
    }


    @Phantom proc nextBytes_loop (i: int, bytes: array<byte>): void
    {
        bytes[i] = action SYMBOLIC("byte");
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


    @synchronized fun *.setSeed (@target self: SecureRandom, seed: array<byte>): void
    {
        action DO_NOTHING();
    }


    fun *.setSeed (@target self: SecureRandom, seed: long): void
    {
        action DO_NOTHING();
    }

}