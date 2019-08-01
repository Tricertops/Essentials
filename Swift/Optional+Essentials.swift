//
//  Optional+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK: - Unwrapping

infix operator !! : TernaryPrecedence

/// Unwrapping optionals with custom message.
/// > `array.first !! "This array must not be empty"`
public func !! <Value>(_ optional: Value?, _ message: String) -> Value {
    if let value = optional {
        return value
    }
    else {
        fatalError(message)
    }
}


