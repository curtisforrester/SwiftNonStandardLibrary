//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information

import Foundation

extension SequenceOf {
    
    //todo: (validate that each of these doesn't already exist in the swift libraries - no sense in reinventing the wheel.
    //
    //aggregate
    //average
    //first
    //last
    //distinct
    //orderBy
    //orderByDescending
    //max
    //min
    //union
    //single
    //skip
    //skipWhile
    //sum
    //take
    //takeWhile
    
    //parallel - this is a *big* one; it will take some work to make this happen using appropriate queues and whatnot.
    //          there is already some of what we need in the form of partitioning, but we have to potentially preserve the order
    //          we will need wrappers of our own for this that inherit from SequenceOf<T>

    
    ///Project elements of a sequence into a new sequence
    func select<U>(transform: T->U) -> SequenceOf<U> {
        return SequenceOf<U> { ()->GeneratorOf<U> in
            var generator = self.generate()
            return GeneratorOf<U> {
                if let value = generator.next() {
                    return transform(value)
                }
                else {
                    return nil;
                }
            }
        }
    }
    
    ///Filter elements of a sequence
    func filter(filter: T->Bool) -> SequenceOf<T> {
        return SequenceOf<T> { ()->GeneratorOf<T> in
            var generator = self.generate()
            return GeneratorOf<T> {
                while true {
                    if let value = generator.next() {
                        if filter(value) {
                            return value
                        } else {
                            continue
                        }
                    } else {
                        return nil
                    }
                }
            }
        }
    }

    ///Perform an outer join of elements in this sequence, matching elements in the target sequence (regardless of types) using the given keys and projecting the desired result
    func outerJoin<TKey:Hashable, ResultType>(outerKey:(T)->TKey, inner:SequenceOf<T>, innerKey:(T)->TKey, result:(T,T,TKey)->ResultType) -> SequenceOf<ResultType> {
            return SequenceOf<ResultType> { ()->GeneratorOf<ResultType> in
                var lookup = Dictionary<TKey, T>()
                for item in self {
                    lookup.updateValue(item, forKey: outerKey(item))
                }
                
                var generator = inner.generate()
                return GeneratorOf<ResultType> {
                    while true {
                        if let value = generator.next() {
                            let k = innerKey(value)
                            if let match = lookup[k] {
                                return result(match, value, k)
                            }
                            else {
                                continue
                            }
                        }
                        else {
                            return nil;
                        }
                    }
                }
            }
    }
    
    ///Perform an outer join of elements in this sequence, matching elements in the target sequence of the same type on the given key and projecting the desired result
    func outerJoin<TKey:Hashable, ResultType>(inner:SequenceOf<T>, key:(T)->TKey, result:(T,T, TKey)->ResultType) -> SequenceOf<ResultType> {
        return outerJoin(key, inner: inner, innerKey: key, result: result)
    }
    
    ///Perform an outer join of elements in this sequence, matching elements in the target sequence of the same type using the given key.
    ///Result is a tuple for each match containing (ThisSequenceObj,InnerSequenceObj,Key)
    func outerJoin<TKey:Hashable>(inner:SequenceOf<T>, key:(T)->TKey) -> SequenceOf<(T,T,TKey)> {
        return outerJoin(inner, key, { ($0, $1, $2) })
    }

    ///Groups elements of the sequence using the given key and projecting the desired result.
    ///
    ///Returns a tuple (key, count, matching elements)
    func groupBy<TKey:Hashable, TResult>(key:(T)->TKey?, select:(T)->TResult) -> SequenceOf<(TKey, Int, SequenceOf<TResult>)> {
        return SequenceOf<(TKey, Int, SequenceOf<TResult>)> { ()->GeneratorOf<(TKey, Int, SequenceOf<TResult>)> in
            var groups = Dictionary<TKey, GroupByGroup<TKey, TResult>>()
            for item in self {
                let keyValue = key(item)
                if let k = keyValue {
                    var groupInfo = groups[k]
                    if groupInfo == nil {
                        groupInfo = GroupByGroup(key: k)
                        groups[k] = groupInfo
                    }
                    
                    if var g = groupInfo {
                        g.addItem(select(item))
                    }
                }
            }
            
            var generator = groups.generate()
            return GeneratorOf<(TKey, Int, SequenceOf<TResult>)> {
                if let (k, v) = generator.next() {
                    return (v.key[0], v.items.count, SequenceOf<TResult>(v.items))
                } else {
                    return nil;
                }
            }
        }
    }
    
    ///Converts the sequence to an array
    func toArray() -> T[] {
        return Array(self)
    }
    
    ///Converts the sequence to an array, transforming each element of the sequence to the desired value
    func toArray<TResult>(transform:T->TResult) -> TResult[] {
        return Array(self.select(transform))
    }
    
    ///Converts the sequence into a Dictionary using the given key and value selectors
    func toDictionary<TKey:Hashable, TValue>(key:(T)->TKey, value:(T)->TValue) -> Dictionary<TKey, TValue> {
        var result: Dictionary<TKey, TValue> = [:]
        for elem in self {
            result[key(elem)] = value(elem)
        }
        return result
    }
    
    ///Converts the sequence into a Dictionary, using the given key selector. The value is the original object from the sequence.
    func toDictionary<TKey:Hashable>(key:(T)->TKey) -> Dictionary<TKey, T> {
        return toDictionary(key, { $0 })
    }
    
}


class GroupByGroup<TKey, TResult> {
    var key:TKey[]
    var items:TResult[]

    init(key:TKey) {
        self.key = [key]
        self.items = []
    }

    func addItem(item: TResult) {
        self.items.append(item)
    }
}










