Swift Non-Standard Library
==========================

**NOTE:** This project is way out of date. I am currently working on a new release that
includes all the useful bits I've collected while writing Swift code, it should be out soon.



Current areas of interest:

1. Sequences
    - Providing LINQ-like operators, but not just copying what LINQ does - make the API flow naturally with Swift
    - Memoizing an iterated sequence - this is waiting on extension stored properties to hold the materialized sequence
    - Need to do more methods like groupJoin, orderBy, etc. Some stuff already exists as global functions. 
    - Also investigate streams, eg Zip2. Will Apple do an actual Streams API that makes some of this moot?
    - Future goals are to optimize for performance

2. GCD 
    - Design a futures style API to abstract away certain things and make GCD trivial to use
    - Probably use trailing closure syntax so you can do async { }, sync { }, mainThread { }
    - NOT YET IMPLEMENTED
    
3. Exceptions
    - Since CoreData throws them, we have to deal with them. Provides ability to catch exceptions in Swift


4. Tuples
    - Some convenience functions and operators to allow comparing and hashing tuples as long as all
        elements in the tuple support Equatable or Hashable. Should be useful in supporting composite keys in Sequences

