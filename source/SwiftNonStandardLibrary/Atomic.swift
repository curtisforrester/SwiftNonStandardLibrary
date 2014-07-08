//
//  Atomic.swift
//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

import Foundation

//WARNING: not yet tested, do not rely on this code
@final class Atomic<T> {
    var _value:UnsafePointer<COpaquePointer>
    
    init(_ initialValue:Box<T>) {
        //retain the object and get its pointer
        let ptr = Unmanaged.passRetained(initialValue).toOpaque()
        //now store that object pointer indirectly (_value will be pointer-to-pointer)
        _value = UnsafePointer<COpaquePointer>.alloc(1)
        _value.initialize(ptr)
    }
    
    deinit {
        let unmanaged = Unmanaged<Box<T>>.fromOpaque(_value.memory)
        unmanaged.release()
        _value.dealloc(1)
    }
    
    var value : Box<T> {
    get {
        return Unmanaged<Box<T>>.fromOpaque(_value.memory).takeUnretainedValue()
    }
    set {
        let unmanaged = Unmanaged.passRetained(newValue)
        let newPtr = unmanaged.toOpaque()
        let oldPtr = _value.memory
        
        let didUpdate = OSAtomicCompareAndSwapPtr(oldPtr, newPtr, _value)
        
        if didUpdate {
            //if swap was done, release old value
            Unmanaged<Box<T>>.fromOpaque(oldPtr).release()
        } else {
            //if swap was not done, we did an unbalanced retain that needs to be fixed
            unmanaged.release()
        }
    }
    }
    
    @conversion func __conversion() -> T {
        return value
    }
    
}
