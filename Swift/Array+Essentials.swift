//
//  Array+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK: - Contents

extension Array {

    /// Returns nil if the array is empty.
    /// > `array.nonEmpty ?? [default]`
    public var nonEmpty: [Element]? {
        return self.isEmpty ? nil : self
    }

    /// Negation of isEmpty to avoid double-negation as `!array.isEmpty`.
    public var hasElements: Bool {
        return !self.isEmpty
    }

    /// Subscript safe for out-of-range indexes.
    /// > `array[optional: 34]`
    public subscript(optional index: Int) -> Element? {
        if index < 0 {
            return nil
        }
        if index >= self.count {
            return nil
        }
        return self[index]
    }

}


//MARK: - Indexes

extension Array {
    
    /// Range of all indexes of this array.
    /// > `for index in array.indexes { ... }`
    public var indexes: CountableRange<Int> {
        return 0 ..< self.count
    }
    
    /// Compound lazy collection for elements with index.
    /// > `for (index, element) in array.withIndexes { ... }`
    public var withIndexes: Array<(Int, Element)> {
        return self.indexes.lazy.map { index in
            return (index, self[index])
        }
    }
    
}


//MARK: - Operations

extension Array {
    
    /// Test of membership using arbitrary comparator.
    /// > `array.contains(self, ===)`
    public func contains(_ element: Element, by comparator: (Element, Element) -> Bool) -> Bool {
        for each in self {
            if comparator(each, element) {
                return yes
            }
        }
        return no
    }
    
}


