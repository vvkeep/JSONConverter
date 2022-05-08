//
//  JavaBuilder.swift
//  JSONConverter
//
//  Created by Yao on 2021/12/11.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation

class JavaBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return  lang == .Java
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\tprivate String \(tempKeyName);\n"
        case .Int:
            return "\tprivate Integer \(tempKeyName);\n"
        case .Float:
            return "\tprivate Float \(tempKeyName);\n"
        case .Double:
            return "\tprivate Double \(tempKeyName);\n"
        case .Bool:
            return "\tprivate Boolean \(tempKeyName);\n"
        case .Dictionary:
            return "\tprivate \(keyTypeName!) \(tempKeyName);\n"
        case .ArrayString, .ArrayNull:
            return "\tprivate List<String> \(tempKeyName);\n"
        case .ArrayInt:
            return "\tprivate List<Integer> \(tempKeyName);\n"
        case .ArrayFloat:
            return "\tprivate List<Float> \(tempKeyName);\n"
        case .ArrayDouble:
            return "\tprivate List<Double> \(tempKeyName);\n"
        case .ArrayBool:
            return "\tprivate List<Boolean> \(tempKeyName);\n"
        case .ArrayDictionary:
            return "\tprivate List<\(keyTypeName!)> \(tempKeyName);\n"
        }
    }
    
    func propertyGetterText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return """
                \tpublic String get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .Int:
            return """
                \tpublic Integer get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .Float:
            return """
                \tpublic Float get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .Double:
            return """
                \tpublic Double get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .Bool:
            return """
                \tpublic Boolean get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .Dictionary:
            return """
                \tpublic \(keyTypeName!) get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .ArrayString, .ArrayNull:
            return """
                \tpublic List<String> get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .ArrayInt:
            return """
                \tpublic List<Integer> get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .ArrayFloat:
            return """
                \tpublic List<Float> get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .ArrayDouble:
            return """
                \tpublic List<Double> get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .ArrayBool:
            return """
                \tpublic List<Boolean> get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        case .ArrayDictionary:
            return """
                \tpublic List<\(keyTypeName!)> get\(tempKeyName.uppercaseFirstChar())() {
                \t\treturn \(tempKeyName);
                \t}\n\n
                """
        }
    }
    
    func propertySetterText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(String \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .Int:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(Integer \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .Float:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(Float \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .Double:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(Double \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .Bool:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(Boolean \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .Dictionary:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(\(keyTypeName!) \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .ArrayString, .ArrayNull:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(List<String> \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .ArrayInt:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(List<Integer> \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .ArrayFloat:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(List<Float> \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .ArrayDouble:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(List<Double> \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .ArrayBool:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(List<Boolean> \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        case .ArrayDictionary:
            return """
                \tpublic void set\(tempKeyName.uppercaseFirstChar())(List<\(keyTypeName!)> \(tempKeyName)) {
                \t\tthis.\(tempKeyName) = \(tempKeyName);
                \t}\n\n
                """
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        if StringUtils.isEmpty(clsText) {
            return "implements Serializable"
        } else {
            return "extends \(clsText!)"
        }
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: inout String, propertiesInitText: inout String?, propertiesGetterSetterText: inout String?) -> String {
        assert(propertiesGetterSetterText != nil, "property getter setter text can't be nil")
        if let getterSetterText = propertiesGetterSetterText, StringUtils.isNotEmpty(getterSetterText) {
            let range = getterSetterText.index(getterSetterText.endIndex, offsetBy: -2)..<getterSetterText.endIndex
            propertiesGetterSetterText?.removeSubrange(range)
        }
        
        return """
            \npublic class \(clsName) \(parentClsName) {
            \(propertiesText)
            \(propertiesGetterSetterText!)
            }\n
            """
    }
    
    func fileSuffix() -> String {
        return "java"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        return"\nimport java.io.Serializable;\nimport java.util.List;\n"
    }
    
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export] {
        let filePath = "\(path)/\(config.rootName.className(withPrefix: config.prefix))"
        return [Export(path: "\(filePath).\(fileSuffix())", content: content)]
    }
}
