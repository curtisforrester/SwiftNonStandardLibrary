//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information

import Foundation

/* 
 These functions support comparing or hashing tuples if all the elements of the tuple
 support Hashable or Equatable
*/

@infix func == <T:Equatable, T2:Equatable> (lhs: (T,T2), rhs: (T,T2)) -> Bool {
    return lhs.0 == rhs.0 &&
        lhs.1 == rhs.1
}

@infix func == <T:Equatable, T2:Equatable, T3:Equatable> (lhs: (T,T2,T3), rhs: (T,T2,T3)) -> Bool {
    return lhs.0 == rhs.0 &&
        lhs.1 == rhs.1 &&
        lhs.2 == rhs.2
}

@infix func == <T:Equatable, T2:Equatable, T3:Equatable, T4:Equatable> (lhs: (T,T2,T3,T4), rhs: (T,T2,T3,T4)) -> Bool {
    return lhs.0 == rhs.0 &&
        lhs.1 == rhs.1 &&
        lhs.2 == rhs.2 &&
        lhs.3 == rhs.3
}

@infix func == <T:Equatable, T2:Equatable, T3:Equatable, T4:Equatable, T5:Equatable> (lhs: (T,T2,T3,T4, T5), rhs: (T,T2,T3,T4, T5)) -> Bool {
    return lhs.0 == rhs.0 &&
        lhs.1 == rhs.1 &&
        lhs.2 == rhs.2 &&
        lhs.3 == rhs.3 &&
        lhs.4 == rhs.4
}

@infix func == <T:Equatable, T2:Equatable, T3:Equatable, T4:Equatable, T5:Equatable, T6:Equatable> (lhs: (T,T2,T3,T4, T5, T6), rhs: (T,T2,T3,T4, T5, T6)) -> Bool {
    return lhs.0 == rhs.0 &&
        lhs.1 == rhs.1 &&
        lhs.2 == rhs.2 &&
        lhs.3 == rhs.3 &&
        lhs.4 == rhs.4 &&
        lhs.5 == rhs.5
}



@infix func != <T:Hashable, T2:Hashable> (lhs: (T,T2), rhs: (T,T2)) -> Bool {
    return lhs.0 != rhs.0 ||
        lhs.1 != rhs.1
}

@infix func != <T:Hashable, T2:Hashable, T3:Hashable> (lhs: (T,T2,T3), rhs: (T,T2,T3)) -> Bool {
    return lhs.0 != rhs.0 ||
        lhs.1 != rhs.1 ||
        lhs.2 != rhs.2
}

@infix func != <T:Hashable, T2:Hashable, T3:Hashable, T4:Hashable> (lhs: (T,T2,T3,T4), rhs: (T,T2,T3,T4)) -> Bool {
    return lhs.0 != rhs.0 ||
        lhs.1 != rhs.1 ||
        lhs.2 != rhs.2 ||
        lhs.3 != rhs.3
}

@infix func != <T:Hashable, T2:Hashable, T3:Hashable, T4:Hashable, T5:Hashable> (lhs: (T,T2,T3,T4, T5), rhs: (T,T2,T3,T4, T5)) -> Bool {
    return lhs.0 != rhs.0 ||
        lhs.1 != rhs.1 ||
        lhs.2 != rhs.2 ||
        lhs.3 != rhs.3 ||
        lhs.4 != rhs.4
}

@infix func != <T:Hashable, T2:Hashable, T3:Hashable, T4:Hashable, T5:Hashable, T6:Hashable> (lhs: (T,T2,T3,T4, T5, T6), rhs: (T,T2,T3,T4, T5, T6)) -> Bool {
    return lhs.0 != rhs.0 ||
        lhs.1 != rhs.1 ||
        lhs.2 != rhs.2 ||
        lhs.3 != rhs.3 ||
        lhs.4 != rhs.4 ||
        lhs.5 != rhs.5
}


func getHash<T:Hashable>(rhs: (T)) -> Int {
    return rhs.0.hashValue
}

func getHash<T:Hashable, T2:Hashable>(rhs: (T,T2)) -> Int {
    return rhs.0.hashValue ^ rhs.1.hashValue
}

func getHash <T:Hashable, T2:Hashable, T3:Hashable> (rhs: (T,T2,T3)) -> Int {
    return rhs.0.hashValue ^ rhs.1.hashValue ^ rhs.2.hashValue
}

func getHash<T:Hashable, T2:Hashable, T3:Hashable, T4:Hashable>(rhs: (T,T2,T3,T4)) -> Int {
    return rhs.0.hashValue ^ rhs.1.hashValue ^ rhs.2.hashValue ^ rhs.3.hashValue
}

func getHash<T:Hashable, T2:Hashable, T3:Hashable, T4:Hashable, T5:Hashable>(rhs: (T,T2,T3,T4,T5)) -> Int {
    return rhs.0.hashValue ^ rhs.1.hashValue ^ rhs.2.hashValue ^ rhs.3.hashValue ^ rhs.4.hashValue
}

func getHash<T:Hashable, T2:Hashable, T3:Hashable, T4:Hashable, T5:Hashable, T6:Hashable>(rhs: (T,T2,T3,T4,T5, T6)) -> Int {
    return rhs.0.hashValue ^ rhs.1.hashValue ^ rhs.2.hashValue ^ rhs.3.hashValue ^ rhs.4.hashValue ^ rhs.5.hashValue
}
