//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

import Foundation


//class Future<T> {
//    
//}
class TaskVoid {
    
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