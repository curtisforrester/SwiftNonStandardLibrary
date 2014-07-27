//
//  Optionals.swift
//  SwiftNonStandardLibrary
//
//  Created by User on 6/28/14.
//  Copyright (c) 2014 User. All rights reserved.
//

import Foundation

operator infix !! { associativity right }

@infix public func !!<T>(left: T?, right: @auto_closure ()->T) -> T {
    return left ? left! : right()
}

public extension Optional {
    public var hasValue: Bool {
    get { return apply(true, false) }
    }
    
    private func apply<U>(caseSome:@auto_closure ()->U,
        _ caseNone:@auto_closure ()->U) -> U {
            switch(self) {
            case .Some:
                return caseSome()
            case .None:
                return caseNone()
            }
    }
}
