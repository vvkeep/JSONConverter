//
//  String+Extension.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/1/28.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
extension String {
    
    func propertyName() -> String {
        return lowercaseFirstChar()
    }
    
    func className(withPrefix prefix: String) -> String {
        return prefix + self.uppercaseFirstChar()
    }
    
    func lowercaseFirstChar() -> String {
        if count > 0{
            let range = Range(startIndex..<index(startIndex, offsetBy: 1))
            let firstLowerChar = self[range].lowercased()
            return replacingCharacters(in: range, with: firstLowerChar)
        }else {
            return self
        }
    }
    
    func uppercaseFirstChar() -> String {
        if count > 0{
            let range = Range(startIndex..<index(startIndex, offsetBy: 1))
            let firstLowerChar = self[range].uppercased()
            return replacingCharacters(in: range, with: firstLowerChar)
        }else {
            return self
        }
    }
}

extension NSNumber {
    
    func valueType() -> YWPropertyType {
        let numberType = CFNumberGetType(self as CFNumber)
        var type: YWPropertyType = .Int
        switch numberType{
        case .charType:
            if (self.int32Value == 0 || self.int32Value == 1){
                type = .Bool
            }else{
                assert(true, "遇见Character类型")
            }
        case .shortType, .intType:
            type = .Int
        case .floatType, .float32Type, .float64Type:
            type = .Float
        case .doubleType, .longType:
            type = .Double
        default:
            type = .Int
        }
        
        return type
    }
}
