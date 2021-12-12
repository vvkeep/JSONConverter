//
//  SwiftBuilder.swift
//  JSONConverter
//
//  Created by Yao on 2021/12/8.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation
class SwiftBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .Swift
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && typeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\tvar \(tempKeyName): String?\n"
        case .Int:
            return "\tvar \(tempKeyName): Int = 0\n"
        case .Float:
            return "\tvar \(tempKeyName): Float = 0.0\n"
        case .Double:
            return "\tvar \(tempKeyName): Double = 0.0\n"
        case .Bool:
            return "\tvar \(tempKeyName): Bool = false\n"
        case .Dictionary:
            return "\tvar \(tempKeyName): \(typeName!)?\n"
        case .ArrayString, .ArrayNull:
            return "\tvar \(tempKeyName) = [String]()\n"
        case .ArrayInt:
            return "\tvar \(tempKeyName) = [Int]()\n"
        case .ArrayFloat:
            return "\tvar \(tempKeyName) = [Float]()\n"
        case .ArrayDouble:
            return "\tvar \(tempKeyName) = [Double]()\n"
        case .ArrayBool:
            return "\tvar \(tempKeyName) = [Bool]()\n"
        case .ArrayDictionary:
            return "\tvar \(tempKeyName) = [\(typeName!)]()\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? "" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: inout String, propertiesInitText: inout String?, propertiesGetterSetterText: inout String?) -> String {
        propertiesText.removeLastChar()
        if structType == .class {
            return "\nclass \(clsName)\(parentClsName) {\n\(propertiesText)\n}\n"
        } else {
            return "\nstruct \(clsName)\(parentClsName) {\n\(propertiesText)\n}\n"
        }
    }
    
    func fileExtension() -> String {
        return "swift"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        return"\nimport Foundation\n"
    }
}
