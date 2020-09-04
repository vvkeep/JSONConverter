//
//  String+Extension.swift
//  JSONConverter
//
//  Created by Yao on 2018/1/28.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation
extension String {
    
    func propertyName() -> String {
        return lowercaseFirstChar()
    }
    
    func className(withPrefix prefix: String?) -> String {
        return (prefix ?? "") + self.uppercaseFirstChar()
    }
    
    func lowercaseFirstChar() -> String {
        if count > 0{
            let range = startIndex..<index(startIndex, offsetBy: 1)
            let firstLowerChar = self[range].lowercased()
            return replacingCharacters(in: range, with: firstLowerChar)
        }else {
            return self
        }
    }
    
    func uppercaseFirstChar() -> String {
        if count > 0{
            let range = startIndex..<index(startIndex, offsetBy: 1)
            let firstLowerChar = self[range].uppercased()
            return replacingCharacters(in: range, with: firstLowerChar)
        }else {
            return self
        }
    }
    
    mutating func removeLastChar() {
        if !self.isEmpty {
            let range = self.index(endIndex, offsetBy: -1)..<self.endIndex
            self.removeSubrange(range)
        }
    }
    
    mutating func removeFistChar() {
        if !self.isEmpty {
            let range = startIndex..<index(startIndex, offsetBy: 1)
            self.removeSubrange(range)
        }
    }
    
    
    static func numSpace(count: Int) -> String {
        var space = ""
        for _ in 0..<count {
            space += "a"
        }
        
        return space
    }
    
    /// 驼峰转为下划线
    mutating func underline() -> String {
        self = lowercaseFirstChar()
        var result = [String]();
        for item in self {
            if item >= "A" && item <= "Z" {
                result.append("_\(item.lowercased())")
            }else {
                result.append(String(item))
            }
        }
        return result.joined()
    }
}

extension NSNumber {
    
    func valueType() -> PropertyType {
        let numberType = CFNumberGetType(self as CFNumber)
        var type: PropertyType = .Int
        switch numberType{
        case .charType:
            if (self.int32Value == 0 || self.int32Value == 1){
                type = .Bool
            }else{
                assert(true, "遇见Character类型")
            }
        case .shortType, .intType, .sInt64Type:
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


// MARK:-  i18n
extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension String{
    
    public func substring(from index: Int) -> String {
        if(self.count > index){
            let startIndex = self.index(self.startIndex,offsetBy: index)
            let subString = self[startIndex..<self.endIndex];
            return String(subString);
        }else{
            return ""
        }
    }
    
    public func substring(to index: Int) -> String {
        if(self.count > index){
            let endindex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endindex]
            return String(subString)
        }else{
            return self
        }
    }
    
    public func subString(rang rangs:NSRange) -> String{
        var string = String()
        if(rangs.location >= 0) && (self.count > (rangs.location + rangs.length)){
            let startIndex = self.index(self.startIndex,offsetBy: rangs.location)
            let endIndex = self.index(self.startIndex,offsetBy: (rangs.location + rangs.length))
            let subString = self[startIndex..<endIndex]
            string = String(subString)
        }
        return string
    }
}
