//
//  Box.swift
//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

import Foundation

class Box<T> {
    //array to work around compiler bug about "unimplemented IR generation feature non-fixed class layout"
    var _value: [T]
    
    init(_ value:T) {
        _value = [value]
    }
    
    var value:T {
    get {
        return _value[0]
    }
    }
    
    @conversion func __conversion() -> T {
        return value
    }
}

class MutableBox<T> : Box<T> {
    //array to work around compiler bug about "unimplemented IR generation feature non-fixed class layout"
    
//    init(_ value:T) {
//        super.init(value)
//    }
    
    override var value:T {
    get {
        return _value[0]
    }
    set {
        _value[0] = newValue
    }
    }
}

