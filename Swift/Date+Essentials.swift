//
//  Date+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK: - Arithmetics

/// Operator + is already implemented in Swift.

/// Calculates difference in seconds between two dates.
public func - (_ A: Date, _ B: Date) -> TimeInterval {
    return A.timeIntervalSinceReferenceDate - B.timeIntervalSinceReferenceDate
}


