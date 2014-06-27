//
//  ThreadingTrampolines.h
//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information
//

@import Darwin;
#import <Foundation/Foundation.h>


extern void oss_pthread_cleanupKey(void *value);
extern pthread_key_t oss_pthread_createKey();


//Note: Swift won't import our C functions unless we fake it with a .h and .m, at least for now.
//      This may just be a defect in the way I've set things up, or a compiler bug of some kind.
