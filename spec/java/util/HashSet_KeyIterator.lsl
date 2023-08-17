libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/HashSet.lsl";

import "list-actions.lsl";


// local semantic types

@GenerateMe
@implements("java.util.Iterator")
@public @final type KeyIterator
    is java.util.HashSet_KeyIterator
    for Iterator
{
}


// === CONSTANTS ===

val HASHSET_KEYITERATOR_VALUE: Object = 0;

// automata

automaton HashSet_KeyIteratorAutomaton
(
    var expectedModCount: int;
    var visitedKeys: map<Object, Object>;
    var parent: HashSet;
)
: KeyIterator
{

    var index: int = 0;
    var currentKey: Object = null;
    var nextWasCalled: boolean = false;

    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];

    // constructors

    @private constructor KeyIterator (@target self: KeyIterator, source: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // utilities

    proc _checkForComodification (): void
    {
        val modCount: int = HashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

    // methods

    fun hasNext (@target self: KeyIterator): boolean
    {
        action ASSUME(this.parent != null);
        val length: int = HashSetAutomaton(this.parent).length;
        result = this.index < length;
    }


    @final fun next (@target self: KeyIterator): Object
    {
        action ASSUME(this.parent != null);
        _checkForComodification();

        val length: int = HashSetAutomaton(this.parent).length;
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        action ASSUME(key != this.currentKey);
        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        val sourceStorageHasKey: bool = action MAP_HAS_KEY(parentStorage, key);
        action ASSUME(sourceStorageHasKey);
        val destStorageHasKey: bool = action MAP_HAS_KEY(this.visitedKeys, key);
        action ASSUME(!destStorageHasKey);

        this.currentKey = key;
        result = key;

        action MAP_SET(this.visitedKeys, this.currentKey, HASHSET_KEYITERATOR_VALUE);
        this.index += 1;
        this.nextWasCalled = true;
    }


    fun remove (@target self: KeyIterator): void
    {
        action ASSUME(this.parent != null);
        val length: int = HashSetAutomaton(this.parent).length;
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition || !this.nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        this.nextWasCalled = false;

        _checkForComodification();

        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        action MAP_REMOVE(parentStorage, this.currentKey);

        this.expectedModCount = HashSetAutomaton(this.parent).modCount;
    }

}