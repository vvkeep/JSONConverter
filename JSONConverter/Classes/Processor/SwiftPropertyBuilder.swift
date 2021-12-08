//
//  SwiftPropertyBuilder.swift
//  JSONConverter
//
//  Created by 姚巍 on 2021/12/8.
//  Copyright © 2021 姚巍. All rights reserved.
//

import Foundation
class SwiftPropertyBuilder: PropertyBuildProtocol {
    
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .Swift || lang == .HandyJSON || lang == .Codable
    }
    
    func propertyText(_ type: PropertyType, keyName: String, typeName: String?) -> String {
        assert((type == .Dictionary || type == .ArrayDictionary) && typeName != nil, " Dictionary type the typeName can not be nil")
        switch type {
        case .String, .null:
            return "\tvar \(keyName): String?\n"
        case .Int:
            return "\tvar \(keyName): Int = 0\n"
        case .Float:
            return "\tvar \(keyName): Float = 0.0\n"
        case .Double:
            return "\tvar \(keyName): Double = 0.0\n"
        case .Bool:
            return "\tvar \(keyName): Bool = false\n"
        case .Dictionary:
            return "\tvar \(keyName): \(typeName!)?\n"
        case .ArrayString, .ArrayNull:
            return "\tvar \(keyName) = [String]()\n"
        case .ArrayInt:
            return "\tvar \(keyName) = [Int]()\n"
        case .ArrayFloat:
            return "\tvar \(keyName) = [Float]()\n"
        case .ArrayDouble:
            return "\tvar \(keyName) = [Double]()\n"
        case .ArrayBool:
            return "\tvar \(keyName) = [Bool]()\n"
        case .ArrayDictionary:
            return "\tvar \(keyName) = [\(typeName!)]()\n"
        }
    }
}
