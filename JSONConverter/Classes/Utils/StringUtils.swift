//
//  StringUtils.swift
//  JSONConverter
//
//  Created by DevYao on 2020/8/29.
//  Copyright © 2020 DevYao. All rights reserved.
//

import Foundation

class StringUtils {
    class func isBlank(_ string: String?) -> Bool{
        if let string = string,
            string.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            return false
        }else {
            return true
        }
    }
    
    class func isNotBlank(_ string: String?) -> Bool{
        return !isBlank(string)
    }
}


