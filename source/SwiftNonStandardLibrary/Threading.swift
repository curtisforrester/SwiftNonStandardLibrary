//
//  Threading.swift
//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

import Darwin
import Foundation


///A Thread-Local data storage slot. Allocate once, then you may access it from multiple threads
///or multiple GCD queues. Each thread/queue will see its own isolated value, unaffected by
///any other threads. 
///
///A ThreadLocalSlot<T> should be declared immutable and usually statically or during initialization
///of the program, then persist for the duration of the program.
///
///
///Note: The OS may place a limit on the total number of slots available; you should not need
///to allocate a large number of slots - that is usually an indication of poor design.
class ThreadLocalSlot<T:AnyObject> {
    let key: pthread_key_t
    
    init(_ initialValue:T?) {
        //bounce to objc land since createkey takes a C function pointer which Swift does not currently deal with
        key = oss_pthread_createKey()
        if initialValue {
            self.value = initialValue
        }
    }
    
    convenience init() {
        self.init(nil)
    }
    
    deinit {
        value = nil //cleanup the value before the key goes away
        pthread_key_delete(key)
    }
    
    var value: T? {
        set {
            //grab old value so we can clean it up
            let oldPtr = pthread_getspecific(key)
            
            //do an unbalanced "retain" so the object will stay alive
            //we are responsible for eventually releasing somewhere
            if newValue {
                let ptr = Unmanaged.passRetained(newValue!)
                pthread_setspecific(key, ptr.toOpaque())
            } else {
                pthread_setspecific(key, nil)
            }
            
            //cleanup the old value
            if oldPtr != nil {
                let unmanaged:Unmanaged<T> = Unmanaged.fromOpaque(oldPtr)
                unmanaged.release() //balance out the retain we did when originally set
            }
        }
        get {
            let ptr = pthread_getspecific(key)
            if ptr != nil {
                let unmanaged:Unmanaged<T> = Unmanaged.fromOpaque(ptr)
                //return unretained value so we dont change retain count
                return unmanaged.takeUnretainedValue()
            }
            
            return nil
        }
    }
}

