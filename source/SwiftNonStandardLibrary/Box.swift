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

public class Box<T> {
    var _value: T
    
    public init(_ value:T) {
        _value = value
    }
    
    public var value:T {
    get {
        return _value
    }
    }
    
    public func __conversion() -> T {
        return value
    }
}

public class MutableBox<T> : Box<T> {
    override public var value:T {
    get {
        return _value
    }
    set {
        _value = newValue
    }
    }
}

