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
    
    init(label:String, kind:QueueKind) {
        _queue = label.withCString { dispatch_queue_create($0, kind.toKind()) }
        oss_dispatch_set_finalizer_f(_queue)
    }
    
    deinit {
        //I think the queue will be released automatically, but need to confirm
    }
    
    ///A context object associated with the queue
    var context: AnyObject? {
    get {
        let ptr = dispatch_get_context(_queue)
        if ptr != nil {
            //let unmanaged:Unmanaged<AnyObject> = Unmanaged.fromOpaque(ptr)
            ////return unretained value so we dont change retain count
            //return unmanaged.takeUnretainedValue() //TODO: Bug here
            
            //use alternate implementation that doesn't crash the compiler
            return oss_void_pointer_to_object_unretained(ptr)
        }
        
        return nil
    }
    set {
        //grab old value so we can clean it up
        let oldPtr = dispatch_get_context(_queue)
        
        //do an unbalanced "retain" so the object will stay alive
        //we are responsible for eventually releasing somewhere
        if newValue {
            let ptr = Unmanaged.passRetained(newValue!)
            dispatch_set_context(_queue, ptr.toOpaque())
        } else {
            dispatch_set_context(_queue, nil)
        }
        
        //cleanup the old value
        if oldPtr != nil {
            let unmanaged:Unmanaged<AnyObject> = Unmanaged.fromOpaque(oldPtr)
            unmanaged.release() //balance out the retain we did when originally set
        }
    }
    }
    
    ///Gets the context object for this queue, cast as type T.
    ///
    ///If no context object is set or the object cannot be cast to the correct type nil is returned
    func getContext<T:AnyObject>() -> T? {
        return self.context as? T
    }
    
    //todo: specific by key as well
    
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