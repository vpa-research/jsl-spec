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
            _getDefaultPRNG_findProvider_loop(i, providersList)
        );

        if (this.provider == null || this.algorithm == null)
            _throwIE();

        this.defaultProvider = _isDefaultProvider(this.provider);
    }


    @Phantom proc _getDefaultPRNG_findProvider_loop (i: int, providersList: array<Provider>): void
    {
        val curProvider: Provider = providersList[i];
        val services: Set = action CALL_METHOD(curProvider, "getServices", []);
        val iter: Iterator = action CALL_METHOD(services, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _getDefaultPRNG_findProvider_findService_loop(iter, curProvider)
        );
    }


    @Phantom proc _getDefaultPRNG_findProvider_findService_loop (iter: Iterator, curProvider: Provider): void
    {
        val curService: Provider_Service = action CALL_METHOD(iter, "next", []) as Provider_Service;
        val curServiceType: String = action CALL_METHOD(curService, "getType", []);

        if (action OBJECT_EQUALS("SecureRandom", curServiceType))
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
        else
            result = false;
    }


    @static proc _nextBytes (result: array<byte>, numBytes: int): void
    {
        val symbolicArray: array<byte> = action SYMBOLIC_ARRAY("byte", numBytes);
        action ARRAY_COPY(symbolicArray, 0, result, 0, numBytes);
    }


    @Phantom proc generateIntArray_loop (i: int, result: array<int>): void
    {
        result[i] = action SYMBOLIC("int");
    }


    proc _generateRandomIntegerArrayWithBounds (size: int, randomNumberOrigin: int, randomNumberBound: int): array<int>
    {
        result = action SYMBOLIC_ARRAY("int", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkIntBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc checkIntBounds_loop (i: int, result: array<int>, randomNumberOrigin: int, randomNumberBound: int): void
    {
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomLongArrayWithBounds (size: int, randomNumberOrigin: long, randomNumberBound: long): array<long>
    {
        result = action SYMBOLIC_ARRAY("long", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkLongBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc checkLongBounds_loop (i: int, result: array<long>, randomNumberOrigin: long, randomNumberBound: long): void
    {
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomDoubleArrayWithBounds (size: int, randomNumberOrigin: double, randomNumberBound: double): array<double>
    {
        result = action SYMBOLIC_ARRAY("double", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkDoubleBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc checkDoubleBounds_loop (i: int, result: array<double>, randomNumberOrigin: double, randomNumberBound: double): void
    {
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
    @static fun *.getInstance (_algorithm: String): SecureRandom
    {
        val providersList: array<Provider> = action CALL_METHOD(null as Security, "getProviders", []);
        val providersListLength: int = action ARRAY_SIZE(providersList);
        var resultProvider: Provider = null;
        var resultAlgorithm: String = null;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, providersListLength, +1,
            findAlgorithmByAllProviders_loop(i, providersList, _algorithm, resultProvider, resultAlgorithm)
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


    @Phantom proc findAlgorithmByAllProviders_loop (i: int, providersList: array<Provider>, _algorithm: String, resultProvider: Provider, resultAlgorithm: String): void
    {
        val curProvider: Provider = providersList[i];
        val services: Set = action CALL_METHOD(curProvider, "getServices", []);
        val iter: Iterator = action CALL_METHOD(services, "iterator", []);
        resultProvider = curProvider;

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            findAlgorithm_loop(iter, curProvider, _algorithm, resultAlgorithm)
        );
    }


    @Phantom proc findAlgorithm_loop (iter: Iterator, curProvider: Provider, _algorithm: String, resultAlgorithm: String): void
    {
        val curService: Provider_Service = action CALL_METHOD(iter, "next", []) as Provider_Service;
        val curServiceType: String = action CALL_METHOD(curService, "getType", []);
        val curServiceAlgorithm: String = action CALL_METHOD(curService, "getAlgorithm", []);

        if (action OBJECT_EQUALS("SecureRandom", curServiceType) && action OBJECT_EQUALS(curServiceAlgorithm, _algorithm))
        {
            resultAlgorithm = curServiceAlgorithm;
            action LOOP_BREAK();
        }
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (_algorithm: String, provider: Provider): SecureRandom
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
            findAlgorithmByAllProviders_loop(i, providersList, _algorithm, resultProvider, resultAlgorithm)
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
    @static fun *.getInstance (_algorithm: String, providerName: String): SecureRandom
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
            findAlgorithmByAllProvidersByName_loop(i, providersList, _algorithm, resultProvider, resultAlgorithm, providerName)
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
        // #note this property can be disabled with SecurityManager. We assume that this situation is impossible,
        // because we can't check enable/disable property status. And we can't invoke "AccessController.doPrivileged" method like in source code;

        val propertyName: String = "securerandom.strongAlgorithms";
        val property: String = action CALL_METHOD(null as Security, "getProperty", [propertyName]);

        if (property == null)
            _throwNSAE();

        val propertyLength: int = action CALL_METHOD(property, "length", []);
        if (propertyLength == 0)
            _throwNSAE();

        val algorithms: array<String> = action CALL_METHOD(property, "split", [","]);
        val algorithmsLength: int = action ARRAY_SIZE(algorithms);

        var j: int = 0;
        action LOOP_FOR(
            j, 0, algorithmsLength, +1,
            findAlg_loop(j, algorithms, result)
        );

        if (result == null)
            _throwNSAE();
    }


    @Phantom proc findAlg_loop (j: int, algorithms: array<String>, result: SecureRandom): void
    {
        val curEntry: String = algorithms[j];
        val algAndProv: array<String> = action CALL_METHOD(curEntry, "split", [":"]);
        val algAndProvLength: int = action ARRAY_SIZE(algAndProv);
        val _algorithm: String = algAndProv[0];

        var resultProvider: Provider = null;
        var resultAlgorithm: String = null;
        val providersList: array<Provider> = action CALL_METHOD(null as Security, "getProviders", []);
        val providersListLength: int = action ARRAY_SIZE(providersList);
        var i: int = 0;

        if (algAndProvLength == 2)
        {
            val providerName: String = algAndProv[1];

            action LOOP_FOR(
                i, 0, providersListLength, +1,
                findAlgorithmByAllProvidersByName_loop(i, providersList, _algorithm, resultProvider, resultAlgorithm, providerName)
            );
        }
        else
        {
            action LOOP_FOR(
                i, 0, providersListLength, +1,
                findAlgorithmByAllProviders_loop(i, providersList, _algorithm, resultProvider, resultAlgorithm)
            );
        }

        if (resultAlgorithm != null)
        {
            val isDefaultProvider: boolean = _isDefaultProvider(resultProvider);

            result = new SecureRandomAutomaton(state = Initialized,
                provider = resultProvider,
                algorithm = resultAlgorithm,
                defaultProvider = isDefaultProvider,
            );

            action LOOP_BREAK();
        }
    }


    @static fun *.getSeed (numBytes: int): array<byte>
    {
        if (numBytes < 0)
            _throwIAE();
        result = action ARRAY_NEW("byte", numBytes);
        _nextBytes(result, numBytes);
    }


    // methods

    // within java.util.Random
    fun *.doubles (@target self: SecureRandom): DoubleStream
    {
        val mass: array<double> = action SYMBOLIC_ARRAY("double", MAX_RANDOM_STREAM_SIZE);

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        val mass: array<double> = _generateRandomDoubleArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound);

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long): DoubleStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<double> = action SYMBOLIC_ARRAY("double", size);

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<double> = _generateRandomDoubleArrayWithBounds(size, randomNumberOrigin, randomNumberBound);

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.generateSeed (@target self: SecureRandom, numBytes: int): array<byte>
    {
        if (numBytes < 0)
            _throwIAE();

        result = action ARRAY_NEW("byte", numBytes);
        _nextBytes(result, numBytes);
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
        val mass: array<int> = action SYMBOLIC_ARRAY("int", MAX_RANDOM_STREAM_SIZE);

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        val mass: array<int> = _generateRandomIntegerArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound);

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long): IntStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<int> = action SYMBOLIC_ARRAY("int", size);

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<int> = _generateRandomIntegerArrayWithBounds(size, randomNumberOrigin, randomNumberBound);

        result = new IntStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom): LongStream
    {
        val mass: array<long> = action SYMBOLIC_ARRAY("long", MAX_RANDOM_STREAM_SIZE);

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long): LongStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<long> = action SYMBOLIC_ARRAY("long", size);

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        val mass: array<long> = _generateRandomLongArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound);

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        var size: int = streamSize as int;
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        val mass: array<long> = _generateRandomLongArrayWithBounds(size, randomNumberOrigin, randomNumberBound);

        result = new LongStreamAutomaton(state = Initialized,
            storage = mass,
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.nextBoolean (@target self: SecureRandom): boolean
    {
        result = action SYMBOLIC("boolean");
    }


    fun *.nextBytes (@target self: SecureRandom, bytes: array<byte>): void
    {
        _nextBytes(bytes, action ARRAY_SIZE(bytes));
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