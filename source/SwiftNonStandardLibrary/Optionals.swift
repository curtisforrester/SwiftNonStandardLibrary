//
//  Optionals.swift
//  SwiftNonStandardLibrary
//
//  Created by User on 6/28/14.
//  Copyright (c) 2014 User. All rights reserved.
//

import Foundation

extension Optional {
    func valueOrDefault(defaultMaker: @auto_closure ()->T) -> T {
        switch self {
        case .Some(let value):
            return value
        default:
            return defaultMaker()
        }
    }
}
