libsl '1.1.0';

library 'std:collections' language 'Java' version '11' url '-';

import 'java-common.lsl';
import 'list-actions.lsl';

include java.util.function.Consumer;

@Public
@Extends('java.util.AbstractSequentialList')
@Implements(['java.util.List','java.util.Deque','java.lang.Cloneable','java.io.Serializable'])
@WrapperMeta(
    src='java.util.LinkedList',
    dst='org.utbot.engine.overrides.collections.UtLinkedList',
    matchInterfaces=true,
)
automaton LinkedList: int(
)
{

}

