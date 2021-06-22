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
    
    /// hump to underline
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
    
    /// underline to hump
    func convertFromSnakeCase() -> String {
        let stringKey = self
        guard !stringKey.isEmpty else { return stringKey }
    
        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }
    
        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }
    
        let keyRange = firstNonUnderscore...lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
    
        let components = stringKey[keyRange].split(separator: "_")
        let joinedString : String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }
    
        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result : String
        if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
            result = joinedString
        } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if (!leadingUnderscoreRange.isEmpty) {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        
        return result
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
