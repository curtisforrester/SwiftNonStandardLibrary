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


extension Unmanaged {
    ///Creates an UnsafePointer<()> to the object.
    ///Be sure you have taken the appropriate retain steps to keep the object alive
    ///before passing the pointer anywhere, or the object may be released and deallocated
    ///out from underneath you, leaving a dangling pointer!
    func toUnsafePtr() -> UnsafePointer<()> {
        return UnsafePointer<()>(self.toOpaque())
    }
    
    ///Converts from an UnsafePointer<()> to an Unmanaged<T> object reference
    ///No retains/releases are performed, so be sure you manage object lifetimes properly.
    ///Passing an invalid pointer or a pointer of the wrong type is
    ///undefined behavior.
    static func fromUnsafePtr(unsafe: UnsafePointer<()>) -> Unmanaged<T> {
        return Unmanaged<T>.fromOpaque(COpaquePointer(unsafe))
    }
}




