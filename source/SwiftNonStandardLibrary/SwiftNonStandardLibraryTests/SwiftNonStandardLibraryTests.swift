//
//  SwiftNonStandardLibraryTests.swift
//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

import Swift
import XCTest
import SwiftNonStandardLibrary

class SwiftNonStandardLibraryTests: XCTestCase {
    
    let seq1 = SequenceOf([
        DataHolder("a", 1),
        DataHolder("b", 2),
        DataHolder("c", 3),
        DataHolder("d", 4),
        DataHolder("e", 5),
        DataHolder("f", 6),
        ])
    
    
    let seq2 = SequenceOf([
        DataHolder("c", 7),
        DataHolder("f", 8),
        DataHolder("g", 9),
        ])
    
    let seq3 = SequenceOf([
        DataHolder("a", 1),
        DataHolder("a", 2),
        DataHolder("a", 3),
        DataHolder("b", 1),
        DataHolder("b", 2),
        DataHolder("c", 1),
        DataHolder("b", 1),
        DataHolder("b", 2),
        DataHolder("c", 2),
        DataHolder("b", 3),
        DataHolder("b", 4),
        DataHolder("c", 3),
        DataHolder("b", 5),
        DataHolder("z", 1),
        DataHolder("z", 2),
        DataHolder("z", 3),
        DataHolder("z", 4),
        DataHolder("z", 5),
        ])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
    func testExceptions() {
        var didTry = false
        var didCatch = false
        var didFinally = false
        
        try {({
            didTry = true
            throw("someException", "failure")
            }, catch: { ex in
                didCatch = true
            }, finally: {
                didFinally = true
            })}
        
        XCTAssert(didTry && didCatch && didFinally, "try, catch, or finally must execute")
    }
    
    //TODO: Uncomment these tests when the compiler is fixed
    func testJoinSequences() {
//        let result = seq1.outerJoin(seq2, key:{ $0.field1 }, { (leftObj: $0, joinedObj: $1, keyValue: $2) })
//        let r2 = seq1.filter({ $0.field2 % 2 == 0 })
//            .outerJoin(seq2, key:{ $0.field1 }, result: { (left, right, key) in  (k: key, v:left.field2 + right.field2) })
//        
//        let arrayResult = Array(result)
//        
//        XCTAssert(arrayResult.count == 2, "Joined result has expected two elements")
//        for item in arrayResult {
//            XCTAssert(item.keyValue == "c" || item.keyValue == "f", "Join item has expected key (c or f)")
//        }
    }
    
    //TODO: Uncomment these tests when the compiler is fixed
    func testGroupBySequences() {
//        //first, do grouping the old fashioned way
//        var oldSchoolCounts: Dictionary<String, Int> = Dictionary()
//        for item in seq3 {
//            let optCount = oldSchoolCounts[item.field1]
//            let count = (optCount ? optCount! : 0) + 1
//            oldSchoolCounts[item.field1] = count
//        }
//        
//        
//        let result = seq3.groupBy({ $0.field1 }, select: { ($0.field2) })
//        
//        let arrayResult = Array(result)
//        XCTAssert(arrayResult.count > 0, "group by produced results")
//        
//        
//        for (key, count, items) in arrayResult {
//            XCTAssert(count == oldSchoolCounts[key], "Expected count = \(oldSchoolCounts[key]), found count = \(count)")
//            
//            let itemArray = Array(items)
//            XCTAssert(count == itemArray.count, "Items array count")
//        }
    }
    
    func testTupleEquality() {
        let t1 = (1, 2, "a")
        let t2 = (1, 2, "b")
        let t3 = (1, 2, "a")
        XCTAssert(t1 != t2, "tuples not equal")
        XCTAssert(t1 == t3, "tuples are equal")
    }
    
    func testTupleHash() {
        let tup = (1, 2.2, "a")
        let expected = 1.hashValue ^ 2.2.hashValue ^ "a".hashValue
        let actual = getHash(tup)
        XCTAssert(expected == actual, "hash value match")
    }
    
    func testThreadLocalSlotSingleThread() {
        let s = ThreadLocalSlot<NSString>()
        let i = 592
        s.value = "\(i)"
        
        XCTAssert(s.value == "592", "slot must have expected value")
    }
    
    func testThreadLocalSlotSingleSwiftObject() {
        let s:ThreadLocalSlot<NonObjcCompatibleObject<Int>> = ThreadLocalSlot()
        s.value = NonObjcCompatibleObject(v: 5)
        
        XCTAssert(s.value?.xyz[0] == 5, "slot expects non-objc object with xyz == 5")
    }
    
    func testOptionalExtensions() {
        var optString:String?
        var optNumber:Int? = 5
        
        XCTAssert(optString.hasValue == false, "optString should be nil, so hasValue expected to be false")
        XCTAssert(optNumber.hasValue, "optNumber should be 5, so hasValue expected to be true")
        
        var coalescedString = optString !! "alternate"
        var coalescedNumber = optNumber !! 10
        
        XCTAssert(coalescedString == "alternate", "string coalesce should have chosen alternate value since string was nil")
        XCTAssert(coalescedNumber == 5, "number coalesce should have chosen original value since it was non-nil")
    }

    //TODO: the GCD tests fail now; something changed in beta 4 that makes the swift dynamic cast fail
//    func testThreadLocalSlotGCD() {
//        let x:ThreadLocalSlot<NSString> = ThreadLocalSlot()
//        let myqueue = dispatch_queue_create("com.obsolete-software.testQueue", DISPATCH_QUEUE_CONCURRENT)
//        
//        x.value = "main"
//        var count = 0
//        var completeCount = UnsafePointer<Int32>.alloc(sizeof(Int32))
//        completeCount.initialize(0)
//        
//        for var i = 0; i < 50; i++ {
//            dispatch_async(myqueue) {
//                let myStr = "op \(count++)"
//                x.value = myStr
//                for var v = 0; v < 500; v++ {
//                    XCTAssert(x.value == myStr, "operation must have expected value not in conflict with other operations")
//                }
//                OSAtomicIncrement32(completeCount)
//            }
//        }
//        
//        dispatch_barrier_sync(myqueue) {
//            //wait for the queued blocks to complete
//        }
//        
//        XCTAssert(completeCount.memory == 50, "expected 50 queued bocks to complete")
//        
//        XCTAssert(x.value == "main", "slot has expected value after all operations finished")
//        
//        completeCount.dealloc(sizeof(Int32))
//    }
    
//    func testQueueContext() {
//        let queue = Queue("com.obsolete-software.testQueue.context", .Concurrent)
//        queue.context = "an object"
//        XCTAssert(queue.context as String == "an object", "queue context object is string")
//        
//        queue.context = DataHolder("ok", 42)
//        let d = queue.context as DataHolder
//        XCTAssert(d.field1 == "ok" && d.field2 == 42, "queue context object is a valid object that lived")
//    }
    
}

class NonObjcCompatibleObject<T> {
    var xyz:[T]
    init(v:T) {
        xyz = [v]
    }
}

class DataHolder {
    var field1: String
    var field2: Int
    
    init(_ f1: String, _ f2: Int) {
        self.field1 = f1
        self.field2 = f2
    }
}