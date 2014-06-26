//
//  SwiftNonStandardLibrary_iOSTests.swift
//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information

import XCTest
import SwiftNonStandardLibrary_iOS

class SwiftNonStandardLibrary_iOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testJoinSequences() {
        //XCTAssert(true, "")
        var seq1 = SequenceOf([
            DataHolder("a", 1),
            DataHolder("b", 2),
            DataHolder("c", 3),
            DataHolder("d", 4),
            DataHolder("e", 5),
            DataHolder("f", 6),
            ])
        
        var seq2 = SequenceOf([
            DataHolder("c", 7),
            DataHolder("f", 8),
            DataHolder("g", 9),
            ])
        
        let result = seq1.Join(seq2, { $0.field1 }, { (leftObj: $0, joinedObj: $1, keyValue: $2) })
        
        let arrayResult = Array(result)
        
        XCTAssert(arrayResult.count == 2, "Joined result has expected two elements")
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