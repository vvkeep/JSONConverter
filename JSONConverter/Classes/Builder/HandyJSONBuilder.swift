//
//  HandyJSONBuilder.swift
//  JSONConverter
//
//  Created by DevYao on 2021/12/10.
//  Copyright © 2021 . All rights reserved.
//

import Foundation

class HandyJSONBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return  lang == .HandyJSON
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
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
            return "\tvar \(tempKeyName): \(keyTypeName!)?\n"
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
            return "\tvar \(tempKeyName) = [\(keyTypeName!)]()\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? ": HandyJSON" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: String, propertiesInitText: String?, propertiesGetterSetterText: String?) -> String {
        if structType == .class {
            return "\nclass \(clsName)\(parentClsName) {\n\(propertiesText)\n\trequired init() {}\n}\n"
        } else {
            let tempPropertiesText = StringUtils.removeLastChar(propertiesText)
            return "\nstruct \(clsName)\(parentClsName) {\n\(tempPropertiesText)\n}\n"
        }
    }
    
    func fileSuffix() -> String {
        return "swift"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        return"\nimport Foundation\nimport HandyJSON\n"
    }
    
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export] {
        let filePath = "\(path)/\(config.rootName.className(withPrefix: config.prefix))"
        return [Export(path: "\(filePath).\(fileSuffix())", content: content)]
    }
}
