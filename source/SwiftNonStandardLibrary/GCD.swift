//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

import Foundation

enum QueueKind {
    case Serial
    case Concurrent
    
    func toKind() -> dispatch_queue_attr_t? {
        switch self {
        case .Concurrent:
            return DISPATCH_QUEUE_CONCURRENT
        default:
            return nil
        }
    }
}



///A GCD Queue for scheduling closures to execute
class Queue {
    let _queue:dispatch_queue_t
    var _keys:Dictionary<String, UnsafePointer<()>> = [:]
    
    init(_ label:String, _ kind:QueueKind) {
        _queue = label.withCString { dispatch_queue_create($0, kind.toKind()) }
        oss_dispatch_set_finalizer_f(_queue)
    }
    
    deinit {
        for (key, value) in _keys {
            value.dealloc(1)
        }
        
        dispatch_release(_queue)
    }
    
    ///A context object associated with the queue
    var context: AnyObject? {
        get {
            return getObjectAtPointer(dispatch_get_context(_queue))
        }
        set {
            setObjectAtPointer(newValue, dispatch_get_context(_queue), { dispatch_set_context(self._queue, $0) })
        }
    }
    
    ///Gets the context object for this queue, cast as type T.
    ///
    ///If no context object is set or the object cannot be cast to the correct type nil is returned
    func getContext<T:AnyObject>() -> T? {
        return self.context as? T
    }
    
    func getSpecific<T:AnyObject>(key:String) -> T? {
        return getObjectAtPointer(dispatch_queue_get_specific(_queue, ptrForKey(key)))
    }
    
    func setSpecific<T:AnyObject>(key:String, value:T?) {
        let keyPointer = ptrForKey(key)
        setObjectAtPointer(value, dispatch_get_specific(keyPointer), { oss_dispatch_queue_set_specific(self._queue, keyPointer, $0) })
    }
    
    func ptrForKey(key:String)->UnsafePointer<()> {
        var result = _keys[key]
        if !result {
            result = result.valueOrDefault(UnsafePointer<Int>.alloc(1))
            _keys[key] = result
        }
        return result!
    }
    
    func async(block: @auto_closure ()->()) -> TaskVoid {
        dispatch_async(_queue, block)
        return TaskVoid()
    }
    
    func async<T>(block: @auto_closure ()->T) -> Task<T> {
        dispatch_async(_queue, {
            block()
            return
        })
        return Task()
    }
    
//    func sync(block: @auto_closure ()->()) {
//    
//    }
//    
//    func sync<T>(block: @auto_closure ()->T) -> T {
//    }
    
    ///Waits for all currently scheduled blocks to finish
    ///
    ///If you call this method from a block executing on this queue,
    ///your application will deadlock.
    func waitForCompletion() {
        dispatch_barrier_sync(_queue) { }
    }
    
    //also the submitting of items to be executed,
    //wait of some kind with detection for serial queue deadlock
    //
    
}




//class Future<T> {
//
//}
class TaskVoid {
    //wait, what others??
}

class Task<T> : TaskVoid {
    
}

//todo: should these be members of task??
//we want to support then, handling errors, and whatnot

func async(block: @auto_closure ()->()) -> TaskVoid {
    return TaskVoid()
    
    //dispatch async, but in the block we can set a context
    //that then becomes accessible to the closure,
    //and cleanup after
}

func async<T>(block: @auto_closure ()->(T)) -> Task<T> {
    return Task()
    

}