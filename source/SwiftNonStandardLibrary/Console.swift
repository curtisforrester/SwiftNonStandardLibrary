//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information

import Foundation


///reads a line from standard input
///
///@param max:Int
/// specifies the number of bytes to read, must be at least 1 to account for null terminator.
///
///
///@return
/// the string, or nil if an error was encountered trying to read Stdin
func readln(max:Int = 8192) -> String? {
    var buf:Array<CChar> = []
    var c = getchar()
    let maxBuf = max - 1;
    let newline = CInt(10)
    assert(maxBuf > 1, "max must be between 1 and Int.max")
    
    while c != EOF && c != newline && buf.count < max {
        buf += CChar(c)
        c = getchar()
    }
    
    //always null terminate
    buf += CChar(0)

    return buf.withUnsafePointerToElements { String.fromCString(CString($0)) }
}
