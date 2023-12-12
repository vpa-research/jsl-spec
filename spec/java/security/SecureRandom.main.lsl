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
    var defaultProvider: boolean,
)
: SecureRandomLSL
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (SecureRandom),
        `<init>` (SecureRandom, SecureRandomSpi, Provider),
        `<init>` (SecureRandom, SecureRandomSpi, Provider, String),
        `<init>` (SecureRandom, array<byte>),

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
        action ERROR("java.lang.InternalError"); // action THROW_NEW("java.lang.InternalError", []);
    }


    @AutoInline @Phantom proc _throwNSPE (): void
    {
        action THROW_NEW("java.security.NoSuchProviderException", []);
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _getDefaultPRNG (): void
    {
        /*
        this.provider = action SYMBOLIC("java.security.Provider");

        this.algorithm = action SYMBOLIC("java.lang.String");
        action ASSUME(action CALL_METHOD(this.algorithm, "length", []) > 0);

        if (this.provider == null || this.algorithm == null)
            _throwIE();
        */
        this.provider = null; // #problem: approximate the provider (symbolic is too dificult for the USVM)
        this.algorithm = "SHA1PRNG"; // #todo: get from the provider

        this.defaultProvider = _isDefaultProvider(this.provider);
    }


    @static proc _isDefaultProvider (curProvider: Provider): boolean
    {
        if (curProvider == null)
        {
            result = false; // no visible effect on anything
        }
        else
        {
            val providerName: String = action CALL_METHOD(curProvider, "getName", []);
            result = action MAP_HAS_KEY(this.defaultProvidersMap, providerName);
        }
    }


    proc _generateRandomIntegerArrayWithBounds (size: int, randomNumberOrigin: int, randomNumberBound: int): array<int>
    {
        result = action SYMBOLIC_ARRAY("int", size);

        // #problem: too complex for symbolic execution
        /*
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkIntBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
        */
    }


    @Phantom proc checkIntBounds_loop (i: int, result: array<int>, randomNumberOrigin: int, randomNumberBound: int): void
    {
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomLongArrayWithBounds (size: int, randomNumberOrigin: long, randomNumberBound: long): array<long>
    {
        result = action SYMBOLIC_ARRAY("long", size);

        // #problem: too complex for symbolic execution
        /*
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkLongBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
        */
    }


    @Phantom proc checkLongBounds_loop (i: int, result: array<long>, randomNumberOrigin: long, randomNumberBound: long): void
    {
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomDoubleArrayWithBounds (size: int, randomNumberOrigin: double, randomNumberBound: double): array<double>
    {
        result = action SYMBOLIC_ARRAY("double", size);

        // #problem: too complex for symbolic execution
        /*
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkDoubleBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
        */
    }


    @Phantom proc checkDoubleBounds_loop (i: int, result: array<double>, randomNumberOrigin: double, randomNumberBound: double): void
    {
        val item: double = result[i];
        action ASSUME(item == item);
        action ASSUME(item >= randomNumberOrigin);
        action ASSUME(item < randomNumberBound);
        result[i] = item;
    }


    // constructors

    constructor *.`<init>` (@target self: SecureRandom)
    {
        _getDefaultPRNG();
    }


    @protected constructor *.`<init>` (@target self: SecureRandom, secureRandomSpi: SecureRandomSpi, provider: Provider)
    {
        action ERROR("Protected constructor call");
    }


    @private constructor *.`<init>` (@target self: SecureRandom, secureRandomSpi: SecureRandomSpi, provider: Provider, algorithm: String)
    {
        action ERROR("Private constructor call");
    }


    constructor *.`<init>` (@target self: SecureRandom, seed: array<byte>)
    {
        _getDefaultPRNG();
    }


    // static methods

    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (_algorithm: String): SecureRandom
    {
        val resultProvider: Provider = action SYMBOLIC("java.security.Provider");
        val resultAlgorithm: String = action SYMBOLIC("java.lang.String");

        if (resultAlgorithm == null)
            _throwNSAE();

        val resultAlgorithmLength: int = action CALL_METHOD(resultAlgorithm, "length", []);
        action ASSUME(resultAlgorithmLength > 0);

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = _isDefaultProvider(resultProvider),
        );
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstance (_algorithm: String, provider: Provider): SecureRandom
    {
        if (provider == null)
            _throwIAE();

        val resultProvider: Provider = action SYMBOLIC("java.security.Provider");
        val resultAlgorithm: String = action SYMBOLIC("java.lang.String");

        if (resultAlgorithm == null)
            _throwNSAE();

        val resultAlgorithmLength: int = action CALL_METHOD(resultAlgorithm, "length", []);
        action ASSUME(resultAlgorithmLength > 0);

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = _isDefaultProvider(resultProvider),
        );
    }


    @throws(["java.security.NoSuchAlgorithmException", "java.security.NoSuchProviderException"])
    @static fun *.getInstance (_algorithm: String, providerName: String): SecureRandom
    {
        if (providerName == null || action CALL_METHOD(providerName, "length", []) == 0)
            _throwIAE();

        val resultProvider: Provider = action SYMBOLIC("java.security.Provider");
        val resultAlgorithm: String = action SYMBOLIC("java.lang.String");

        if (resultProvider == null)
            _throwNSPE();

        if (resultAlgorithm == null)
            _throwNSAE();

        val resultAlgorithmLength: int = action CALL_METHOD(resultAlgorithm, "length", []);
        action ASSUME(resultAlgorithmLength > 0);

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = _isDefaultProvider(resultProvider),
        );
    }


    @throws(["java.security.NoSuchAlgorithmException"])
    @static fun *.getInstanceStrong (): SecureRandom
    {
        // #note this property can be disabled with SecurityManager. We assume that this situation is impossible,
        // because we can't check enable/disable property status. And we can't invoke "AccessController.doPrivileged" method like in source code;

        val property: String = action CALL_METHOD(null as Security, "getProperty", ["securerandom.strongAlgorithms"]);
        if (property == null)
            _throwNSAE();

        val propertyLength: int = action CALL_METHOD(property, "length", []);
        if (propertyLength == 0)
            _throwNSAE();

        val resultProvider: Provider = action SYMBOLIC("java.security.Provider");
        val resultAlgorithm: String = action SYMBOLIC("java.lang.String");

        if (resultAlgorithm == null)
            _throwNSAE();

        result = new SecureRandomAutomaton(state = Initialized,
            provider = resultProvider,
            algorithm = resultAlgorithm,
            defaultProvider = _isDefaultProvider(resultProvider),
        );
    }


    @static fun *.getSeed (numBytes: int): array<byte>
    {
        if (numBytes < 0)
            _throwIAE();

        result = action SYMBOLIC_ARRAY("byte", numBytes);
    }


    // methods

    // within java.util.Random
    fun *.doubles (@target self: SecureRandom): DoubleStream
    {
        result = new DoubleStreamAutomaton(state = Initialized,
            storage = _generateRandomDoubleArrayWithBounds(MAX_RANDOM_STREAM_SIZE, 0, 1),
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();

        result = new DoubleStreamAutomaton(state = Initialized,
            // #problem: too complex for symbolic execution
            storage = _generateRandomDoubleArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound),
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long): DoubleStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();

        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("double", size),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.doubles (@target self: SecureRandom, streamSize: long, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();

        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = _generateRandomDoubleArrayWithBounds(size, randomNumberOrigin, randomNumberBound),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.generateSeed (@target self: SecureRandom, numBytes: int): array<byte>
    {
        if (numBytes < 0)
            _throwIAE();

        result = action SYMBOLIC_ARRAY("byte", numBytes);
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
        result = new IntStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("int", MAX_RANDOM_STREAM_SIZE),
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();

        result = new IntStreamAutomaton(state = Initialized,
            storage = _generateRandomIntegerArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound),
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long): IntStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();

        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        result = new IntStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("int", size),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.ints (@target self: SecureRandom, streamSize: long, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();

        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        result = new IntStreamAutomaton(state = Initialized,
            storage = _generateRandomIntegerArrayWithBounds(size, randomNumberOrigin, randomNumberBound),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom): LongStream
    {
        result = new LongStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("long", MAX_RANDOM_STREAM_SIZE),
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long): LongStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();

        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        result = new LongStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("long", size),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();

        result = new LongStreamAutomaton(state = Initialized,
            storage = _generateRandomLongArrayWithBounds(MAX_RANDOM_STREAM_SIZE, randomNumberOrigin, randomNumberBound),
            length = MAX_RANDOM_STREAM_SIZE,
            closeHandlers = action LIST_NEW(),
        );
    }


    // within java.util.Random
    fun *.longs (@target self: SecureRandom, streamSize: long, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();

        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > MAX_RANDOM_STREAM_SIZE)
            size = MAX_RANDOM_STREAM_SIZE;

        result = new LongStreamAutomaton(state = Initialized,
            storage = _generateRandomLongArrayWithBounds(size, randomNumberOrigin, randomNumberBound),
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
        val len: int = action ARRAY_SIZE(bytes);
        val src: array<byte> = action SYMBOLIC_ARRAY("byte", len);
        action ARRAY_COPY(src, 0, bytes, 0, len);
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
        val isNaN: boolean = result != result;
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
            _throwIAE();

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
        // #todo: call SecureRandomSpi seed initialization method here
        if (seed == null)
        {
            if (action SYMBOLIC("boolean"))
                _throwNPE();
        }
    }


    fun *.setSeed (@target self: SecureRandom, seed: long): void
    {
        action DO_NOTHING();
    }


    // special: static initialization

    @Phantom @static fun *.`<clinit>` (): void
    {
        // #note: list of default providers https://docs.oracle.com/javase/9/security/oracleproviders.htm#JSSEC-GUID-F41EE1C9-DD6A-4BAB-8979-EB7654094029

        // limiting static field access
        val dpMap: map<String, Object> = defaultProvidersMap;
        val o: Object = SOMETHING;

        action MAP_SET(dpMap, "SUN", o);
        action MAP_SET(dpMap, "SunRsaSign", o);
        action MAP_SET(dpMap, "SunJSSE", o);
        action MAP_SET(dpMap, "SunJCE", o);
        action MAP_SET(dpMap, "Apple", o);

        action MAP_SET(dpMap, "JdkLDAP", o);
        action MAP_SET(dpMap, "SunJGSS", o);
        action MAP_SET(dpMap, "SunSASL", o);
        action MAP_SET(dpMap, "SunPCSC", o);
        action MAP_SET(dpMap, "XMLDSig", o);
        action MAP_SET(dpMap, "SunPKCS11", o);
        action MAP_SET(dpMap, "SunEC", o);
        action MAP_SET(dpMap, "SunMSCAPI", o);
        action MAP_SET(dpMap, "OracleUcrypto", o);
        action MAP_SET(dpMap, "JdkSASL", o);
    }

}