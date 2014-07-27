//
//  Interop.swift
//  SwiftNonStandardLibrary
//
//  Created by User on 6/28/14.
//  Copyright (c) 2014 User. All rights reserved.
//

import Foundation

///Gets the object stored at the pointer, or nil if no object or the types were not compatible
func getObjectAtPointer<T:AnyObject>(ptrGetter: @auto_closure ()->UnsafePointer<()>) -> T? {
    let ptr = ptrGetter()
    if ptr != nil {
        //let unmanaged:Unmanaged<AnyObject> = Unmanaged.fromOpaque(COpaquePointer(ptr))
        //don't alter retain count
        //return unmanaged.takeUnretainedValue() as? T
        
        //still a bug rdar://17492202 as of beta 3
        return oss_void_pointer_to_object_unretained(ptr) as? T
    }
    return nil
}

///Stores an object at the pointer, adding an unbalanced `retain` so the object will stay alive.
///
///If an object was previously stored at the pointer, it will be released. Pass `nil` to
///clear and release the existing value (eg from your deinit)
func setObjectAtPointer<T:AnyObject>(newValue:T?, ptrGetter: @auto_closure ()->UnsafePointer<()>, ptrSetter:(UnsafePointer<()>)->()) {
    //grab old value so we can clean it up
    let oldPtr = ptrGetter()
    if newValue {
        //do an unbalanced "retain" so the object will stay alive
        //we are responsible for eventually releasing somewhere
        let ptr = Unmanaged.passRetained(newValue!)
        ptrSetter(ptr.toUnsafePtr())
    } else {
        ptrSetter(nil)
    }
    
    //cleanup the old value
    if oldPtr != nil {
        let unmanaged:Unmanaged<AnyObject> = Unmanaged.fromUnsafePtr(oldPtr) //Unmanaged.fromOpaque(COpaquePointer(oldPtr))
        unmanaged.release() //balance out the retain we did when originally set
    }
}


public extension Unmanaged {
    ///Creates an UnsafePointer<()> to the object.
    ///Be sure you have taken the appropriate retain steps to keep the object alive
    ///before passing the pointer anywhere, or the object may be released and deallocated
    ///out from underneath you, leaving a dangling pointer!
    public func toUnsafePtr() -> UnsafePointer<()> {
        return UnsafePointer<()>(self.toOpaque())
    }
    
    ///Converts from an UnsafePointer<()> to an Unmanaged<T> object reference
    ///No retains/releases are performed, so be sure you manage object lifetimes properly.
    ///Passing an invalid pointer or a pointer of the wrong type is
    ///undefined behavior.
    static public func fromUnsafePtr(unsafe: UnsafePointer<()>) -> Unmanaged<T> {
        return Unmanaged<T>.fromOpaque(COpaquePointer(unsafe))
    }
}

public extension UnsafePointer {
    ///Writes value to the pointer, optionally repeating repeatCount times.
    ///All use of this function is unsafe and should be reviewed thoroughly
    public func write(value:CChar, repeatCount:UInt = 1) {
        self.write(value, startOffset: 0, repeatCount: repeatCount)
    }
    
    ///Writes value to the pointer, optionally starting at the given offset and repeating for repeatCount.
    ///All use of this function is unsafe and should be reviewed thoroughly
    public func write(value:CChar, startOffset:Int = 0, repeatCount:UInt = 1) {
        memset(UnsafePointer<()>(self + startOffset), Int32(UInt8(value)), repeatCount)
    }
    
    ///Initializes the memory pointed to by UnsafePointer to zero.
    ///num should be the number of objects of T (same as alloc()).
    ///Passing a larger size will stomp on memory and represents a potentially significant security risk;
    ///All use of this function is unsafe and should be reviewed thoroughly
    public func initializeZero(num:Int) {
        self.write(0, startOffset:0, repeatCount:UInt(num))
    }
}

///Represents a vector of CChar, null-terminated, with automatic conversion to String.
///Useful for APIs that want a pointer to write a string result, allowing you to specify the
///max size of the allocation.
///
///This class is initialized to be filled with null, so absent any writes it is always safe to
///use description or convert to String.
///
///Warning: Writes are always responsible for ensuring the terminating null is present!
public class StringBuffer : Printable {
    var length:Int
    var buffer:UnsafePointer<CChar>
    public init(_ capacity:Int) {
        assert(capacity > 0, "capacity must be > 0")
        //We lie and allocate +1 to include one last null as a safety check to prevent buffer
        //overruns when converting back to String, since that conversion is potentially
        //automatic and/or implicit. Users of this class should *NOT* assume that behavior will
        //continue!
        //ALWAYS VERIFY YOUR USE OF POINTERS IS CORRECT, DO NOT RELY ON IMPLEMENTATION DETAILS
        self.length = capacity + 1
        self.buffer = UnsafePointer.alloc(self.length)
        self.buffer.initializeZero(self.length)
    }
    public convenience init(_ capacity:Int32) {
        self.init(Int(capacity))
    }
    deinit {
        self.buffer.dealloc(self.length)
    }
    public func __conversion() -> String? {
        return String.fromCString(self.buffer)
    }
    public func __conversion<T>() -> UnsafePointer<T> {
        return UnsafePointer<T>(self.buffer)
    }
    public var description: String {
    get {
        let s = self as String?
        if let ss = s {
            return ss
        } else {
            return "[empty StringBuffer]"
        }
    }
    }
    public var ulength: UInt {
    get {
        return UInt(self.length)
    }
    }
    public var ulength32: UInt32 {
    get {
        assert(UInt64(self.length) < UInt64(Int32.max), "too big")
        return UInt32(self.length)
    }
    }
}


