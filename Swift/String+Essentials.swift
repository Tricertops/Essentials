//
//  String+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK:  Length & Content

extension String {
    
    /// Returns nil if the string is empty.
    /// > `string.nonEmpty ?? "placeholder"`
    public var nonEmpty: String? {
        return self.isEmpty ? nil : self
    }
    
    /// Alias for count.
    public var length: Int {
        return self.count
    }
    
    /// NSRange that covers the entire string.
    public var fullRange: NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
}


//MARK: - Subscripts

extension String {
    
    /// Subscript for partial range.
    /// > `string[2...]`
    public subscript(_ range: CountablePartialRangeFrom<Int>) -> Substring {
        return self.dropFirst(range.lowerBound)
    }
    
    /// Subscript for partial range.
    /// > `string[...2]`
    public subscript(_ range: PartialRangeThrough<Int>) -> Substring {
        return self.prefix(range.upperBound)
    }
    
    /// Subscript for substring from index.
    public subscript(from index: Int) -> Substring {
        return self[index...]
    }
    
    /// Subscript for substring to index.
    public subscript(to index: Int) -> Substring {
        return self[...index]
    }
    
}


//MARK: - Constants

extension String {
    
    /// Standard \n string.
    public static var newLine: String {
        return "\n"
    }
    
}


//MARK: - Concatenation

/// Operator for concatenating string with any other values.
public func + (_ left: String, _ right: CustomStringConvertible?) -> String {
    return left + (right?.description ?? "nil")
}

/// Operator for concatenating string with any other values.
public func + (_ left: CustomStringConvertible?, _ right: String) -> String {
    return (left?.description ?? "nil") + right
}

/// Operator for concatenating string with any other values.
public func + (_ left: String?, _ right: String?) -> String {
    return (left ?? "nil").appending(right ?? "nil")
}


