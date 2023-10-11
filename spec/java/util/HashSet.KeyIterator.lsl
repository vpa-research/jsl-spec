///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashSet.java";

// imports

import java/util/HashSet;


// automata

automaton HashSet_KeyIteratorAutomaton
(
    var expectedModCount: int,
    var visitedKeys: map<Object, Object>,
    var parent: HashSet
)
: HashSet_KeyIterator
{

    var index: int = 0;
    var currentKey: Object = 0;
    var nextWasCalled: boolean = false;

    // states and shifts

    initstate Allocated;
    state Initialized;

     shift Allocated -> Initialized by [
            // constructors
            // Problem: here mustn't be "HashMap"; What must be here ? What we must to do with constructor ?
            HashSet_KeyIterator,
     ];

    shift Initialized -> self by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];


    // utilities

    proc _checkForComodification (): void
    {
        val modCount: int = HashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // constructors

    @private constructor *.HashSet_KeyIterator (@target self: HashSet_KeyIterator, source: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // methods

    fun *.hasNext (@target self: HashSet_KeyIterator): boolean
    {
        action ASSUME(this.parent != null);
        val length: int = HashSetAutomaton(this.parent).length;
        result = this.index < length;
    }


    @final fun *.next (@target self: HashSet_KeyIterator): Object
    {
        action ASSUME(this.parent != null);
        _checkForComodification();

        val length: int = HashSetAutomaton(this.parent).length;
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition)
            action THROW_NEW("java.util.NoSuchElementException", []);

        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        action ASSUME(key != this.currentKey);
        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        val sourceStorageHasKey: boolean = action MAP_HAS_KEY(parentStorage, key);
        action ASSUME(sourceStorageHasKey);
        val dstStorageHasKey: boolean = action MAP_HAS_KEY(this.visitedKeys, key);
        action ASSUME(!dstStorageHasKey);

        this.currentKey = key;
        result = key;

        action MAP_SET(this.visitedKeys, this.currentKey, SOMETHING);
        this.index += 1;
        this.nextWasCalled = true;
    }


    fun *.remove (@target self: HashSet_KeyIterator): void
    {
        action ASSUME(this.parent != null);

        val length: int = HashSetAutomaton(this.parent).length;
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition || !this.nextWasCalled)
            action THROW_NEW("java.lang.IllegalStateException", []);

        this.nextWasCalled = false;

        _checkForComodification();

        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        action MAP_REMOVE(parentStorage, this.currentKey);

        this.expectedModCount = HashSetAutomaton(this.parent).modCount;
    }


    fun *.forEachRemaining (@target self: HashSet_KeyIterator, userAction: Consumer): void
    {
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        val length: int = HashSetAutomaton(this.parent).length;
        var i: int = this.index;

        action LOOP_WHILE(
            i < length,
            forEachRemaining_loop(userAction, i)
        );

        this.index = i;
        this.nextWasCalled = true;
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): void
    {
        _checkForComodification();

        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        action ASSUME(key != this.currentKey);
        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        val sourceStorageHasKey: boolean = action MAP_HAS_KEY(parentStorage, key);
        action ASSUME(sourceStorageHasKey);
        val destStorageHasKey: boolean = action MAP_HAS_KEY(this.visitedKeys, key);
        action ASSUME(!destStorageHasKey);

        this.currentKey = key;
        action MAP_SET(this.visitedKeys, this.currentKey, SOMETHING);

        action CALL(userAction, [key]);
        i += 1;
    }

}