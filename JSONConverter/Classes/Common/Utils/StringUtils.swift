//
//  StringUtils.swift
//  JSONConverter
//
//  Created by DevYao on 2020/8/29.
//  Copyright © 2020 DevYao. All rights reserved.
//

import Foundation

class StringUtils {
    static func isEmpty(_ string: String?) -> Bool {
        if let string = string,
            string.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            return false
        } else {
            return true
        }
    }
    
    static func isNotEmpty(_ string: String?) -> Bool {
        return !isEmpty(string)
    }
    
    static func removeLastChar(_ string: String) -> String {
        var temp = string
        if isNotEmpty(temp) {
            let range = temp.index(temp.endIndex, offsetBy: -1)..<temp.endIndex
            temp.removeSubrange(range)
        }
        
        return temp
    }
}
