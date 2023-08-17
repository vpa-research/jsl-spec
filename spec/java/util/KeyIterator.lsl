libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/HashMap.lsl";

import "list-actions.lsl";


// local semantic types

@TypeMapping(typeVariable=true) typealias K = Object;

@For(automaton="KeyIteratorAutomaton", insteadOf="java.util.HashMap$KeyIterator")
@extends("java.util.HashMap<K, V>$HashIterator")
@implements(["java.util.Iterator<K>"])
@public @final type KeyIterator
{
    @static @final var mockedValue: Object = Object;
}


// automata

@public automaton KeyIteratorAutomaton: KeyIterator
(
    var index: int = 0;
    var destStorage: map = null;
    var currentKey: K = null;
    var nextWasCalled: boolean = false;
    var expectedModCount: int;
    var sourceStorage: map;
    var parent: HashSet;
)
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> this by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];

    // constructors

    constructor KeyIterator (@target obj: KeyIterator, arg0: HashMap)
    {
        this.destStorage = action MAP_NEW();
        // Problem - what else we must to do in this constructor ???
        action TODO();
    }


    // utilities

    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }

    proc _checkForComodification (): void
    {
        val modCount: int = HashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

    // static methods

    // methods

    fun hasNext (@target obj: KeyIterator): boolean
    {
        val length: int = action MAP_SIZE(map);
        result = this.index < length;
    }

    @final fun next (@target obj: KeyIterator): K
    {
        _checkForComodification();

        val length: int = action MAP_SIZE(map);
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        val key = engine.makeSymbolic(K);
        val sourceStorageHasKey = action MAP_HAS_KEY(this.sourceStorage, key);
        // Assume must be always on the bottom of the method body or not ?
        assume(sourceStorageHasKey);
        val destStorageHasKey = action MAP_HAS_KEY(this.destStorage, key);
        assume(!destStorageHasKey);

        currentKey = key;
        result = key;

        action MAP_SET(this.destStorage, currentKey, this.mockedValue);
        this.index += 1;
        this.nextWasCalled = true;
    }

    fun remove (): void
    {
        val length: int = action MAP_SIZE(map);
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition || !this.nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        this.nextWasCalled = false;

        _checkForComodification();

        action MAP_REMOVE(this.sourceStorage, currentKey);

        this.expectedModCount = HashSetAutomaton(this.parent).modCount;
    }

}