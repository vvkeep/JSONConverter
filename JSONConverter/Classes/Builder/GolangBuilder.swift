//
//  GolangBuilder.swift
//  JSONConverter
//
//  Created by DevYao on 2021/12/24.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation

class GolangBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .Golang
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        assert(!(type.isDictionaryType() && keyTypeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        let spaceText = String.numSpace(count: maxKeyNameLength - (type.isDictionaryType() ? keyTypeName!.count : tempKeyName.count))
        switch type {
        case .String, .Null:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) string `json:\"\(keyName)\"`\n"
        case .Int:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) int `json:\"\(keyName)\"`\n"
        case .Float:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) float64 `json:\"\(keyName)\"`\n"
        case .Double:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) float64 `json:\"\(keyName)\"`\n"
        case .Bool:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) bool `json:\"\(keyName)\"`\n"
        case .Dictionary:
            return "\t \(keyTypeName!.uppercaseFirstChar())\(spaceText) []\(keyTypeName!.uppercaseFirstChar()) `json:\"\(keyName)\"`\n"
        case .ArrayString, .ArrayNull:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) []string `json:\"\(keyName)\"`\n"
        case .ArrayInt:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) []int `json:\"\(keyName)\"`\n"
        case .ArrayFloat:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) []float64 `json:\"\(keyName)\"`\n"
        case .ArrayDouble:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) []float64 `json:\"\(keyName)\"`\n"
        case .ArrayBool:
            return "\t \(tempKeyName.uppercaseFirstChar())\(spaceText) []bool `json:\"\(keyName)\"`\n"
        case .ArrayDictionary:
            return "\t \(keyTypeName!.uppercaseFirstChar())\(spaceText) []\(keyTypeName!.uppercaseFirstChar()) `json:\"\(keyName)\"`\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? "" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: String, propertiesInitText: String?, propertiesGetterSetterText: String?) -> String {
        let tempPropertiesText = StringUtils.removeLastChar(propertiesText)
        return "\ntype \(clsName) struct {\n\(tempPropertiesText)\n}\n"
    }
    
    func fileSuffix() -> String {
        return "go"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        return ""
    }
    
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export] {
        let filePath = "\(path)/\(config.rootName.className(withPrefix: config.prefix))"
        return [Export(path: "\(filePath).\(fileSuffix())", content: content)]
    }
}
