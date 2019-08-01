//
//  OptionSet+Essentials.swift
//  Essentials
//
//  Created by Martin Kiss on 1 Aug 2019.
//  Copyright © 2019 Tricertops. All rights reserved.
//

import Foundation



//MARK: - Counting

extension OptionSet where Self.RawValue: FixedWidthInteger {
    
    /// Returns count of distinct elements in this set.
    public var count: Int {
        return self.rawValue.nonzeroBitCount
    }
    
}


