//
//  Math+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK:  Increment & Decrement

/// C postfix increment operator.
public postfix func ++ <T: AdditiveArithmetic & ExpressibleByIntegerLiteral>(_ value: inout T) {
    value += 1
}


/// C postfix decrement operator.
public postfix func -- <T: AdditiveArithmetic & ExpressibleByIntegerLiteral>(_ value: inout T) {
    value -= 1
}


//MARK: - Percent

postfix operator %

/// Operator for writing percentages.
public postfix func % <T: FloatingPoint & ExpressibleByFloatLiteral>(_ value: T) -> T {
    return value / 100
}


//MARK: - Degrees

postfix operator °

/// Operator for writing degrees, which are converted to radians.
public postfix func ° <T: FloatingPoint & ExpressibleByIntegerLiteral>(_ value: T) -> T {
    return value / 180 * T.pi
}


//MARK: - Square Root

prefix operator √

/// Operator for writing square roots.
public prefix func √ <T: FloatingPoint>(_ value: T) -> T {
    return value.squareRoot()
}


//MARK: - Powers

precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

// Operator ^ already exists and it has priority when used with Int operands.
infix operator ^^ : ExponentiationPrecedence

/// Operator for writing powers.
public func ^^ (_ base: Double, exponent: Double) -> Double {
    return pow(base, exponent)
}


