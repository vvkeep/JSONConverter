//
//  SwiftyJSONBuilder.swift
//  JSONConverter
//
//  Created by DevYao on 2021/12/9.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation

class SwiftyJSONBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .SwiftyJSON
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        assert((type == .Dictionary || type == .ArrayDictionary) && typeName != nil, " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\tvar \(tempKeyName): String\n"
        case .Int:
            return "\tvar \(tempKeyName): Int = 0\n"
        case .Float:
            return "\tvar \(tempKeyName): Float = 0.0\n"
        case .Double:
            return "\tvar \(tempKeyName): Double = 0.0\n"
        case .Bool:
            return "\tvar \(tempKeyName): Bool = false\n"
        case .Dictionary:
            return "\tvar \(tempKeyName): \(typeName!)\n"
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
    
    func initPropertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        assert((type == .Dictionary || type == .ArrayDictionary) && typeName != nil, " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].stringValue\n"
        case .Int:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].intValue\n"
        case .Float:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].floatValue\n"
        case .Double:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].doubleValue\n"
        case .Bool:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].boolValue\n"
        case .Dictionary:
            return "\t\t\(tempKeyName) = \(typeName!)(json: json[\"\(keyName)\"])\n"
        case .ArrayString, .ArrayNull:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].arrayValue.compactMap({$0.stringValue})\n"
        case .ArrayInt:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].arrayValue.compactMap({$0.intValue})\n"
        case .ArrayFloat:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].arrayValue.compactMap({$0.floatValue})\n"
        case .ArrayDouble:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].arrayValue.compactMap({$0.doubleValue})\n"
        case .ArrayBool:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].arrayValue.compactMap({$0.boolValue})\n"
        case .ArrayDictionary:
            return "\t\t\(tempKeyName) = json[\"\(keyName)\"].arrayValue.compactMap({ \(typeName!)(json: $0)})\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? "" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: inout String, propertiesInitText: inout String?) -> String {
        if structType == .class {
            return "\nclass \(clsName)\(parentClsName) {\n\(propertiesText)\n\tinit(json: JSON) {\n\(propertiesInitText!)\t}\n}\n"
        } else {
            return "\nstruct \(clsName)\(parentClsName) {\n\(propertiesText)\n\tinit(json: JSON) {\n\(propertiesInitText!)\t}\n}\n"
        }
    }
}
