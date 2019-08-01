//
//  Bool+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK:  Constants

/// Alias for `false`.
public let no = false

/// Alias for `true`.
public let yes = true


//MARK: - Negation

extension Bool {
    
    /// Postfix notation for Bool negation, this is.
    /// > `if string.isEmpty.not { ... }`
    public var not: Bool {
        return !self
    }
    
}


