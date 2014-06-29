//
//  Interop.swift
//  SwiftNonStandardLibrary
//
//  Created by User on 6/28/14.
//  Copyright (c) 2014 User. All rights reserved.
//

import Foundation

///Gets the object stored at the pointer, or nil if no object or the types were not compatible
func getObjectAtPointer<T:AnyObject>(ptrGetter: @auto_closure ()->COpaquePointer) -> T? {
    let ptr = ptrGetter()
    if ptr != nil {
        //let unmanaged:Unmanaged<AnyObject> = Unmanaged.fromOpaque(ptr)
        ////don't alter retain count
        //return unmanaged.takeUnretainedValue() as? T
        
        //WORKAROUND for compiler bug, rdar://17492202
        return oss_void_pointer_to_object_unretained(ptr) as? T
    }
    return nil
}

///Stores an object at the pointer, adding an unbalanced `retain` so the object will stay alive.
///
///If an object was previously stored at the pointer, it will be released. Pass `nil` to
///clear and release the existing value (eg from your deinit)
func setObjectAtPointer<T:AnyObject>(newValue:T?, ptrGetter: @auto_closure ()->COpaquePointer, ptrSetter:(COpaquePointer)->()) {
    //grab old value so we can clean it up
    let oldPtr = ptrGetter()
    if newValue {
        //do an unbalanced "retain" so the object will stay alive
        //we are responsible for eventually releasing somewhere
        let ptr = Unmanaged.passRetained(newValue!)
        ptrSetter(ptr.toOpaque())
    } else {
        ptrSetter(nil)
    }
    
    //cleanup the old value
    if oldPtr != nil {
        let unmanaged:Unmanaged<AnyObject> = Unmanaged.fromOpaque(oldPtr)
        unmanaged.release() //balance out the retain we did when originally set
    }
}
