//
//  FlutterBuilder.swift
//  JSONConverter
//
//  Created by DevYao on 2021/12/9.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation

class FlutterBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .Flutter
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tString? \(tempKeyName);\n"
        case .Int, .Float, .Double:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tnum? \(tempKeyName);\n"
        case .Bool:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tbool? \(tempKeyName);\n"
        case .Dictionary:
            return "\n\t@JsonKey(name: '\(keyName)')\n\t\(keyTypeName!)? \(tempKeyName);\n"
        case .ArrayString, .ArrayNull:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<String>? \(tempKeyName);\n"
        case .ArrayInt, .ArrayFloat, .ArrayDouble:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<num>? \(tempKeyName);\n"
        case .ArrayBool:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<bool>? \(tempKeyName);\n"
        case .ArrayDictionary:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<\(keyTypeName!)>? \(tempKeyName);\n"
        }
    }
    
    func propertyInitText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        let tempKeyName = strategy.processed(keyName)
        return "this.\(tempKeyName),"
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? " extends Object" : " extends \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: inout String, propertiesInitText: inout String?, propertiesGetterSetterText: inout String?) -> String {
        return "\n@JsonSerializable()\nclass \(clsName)\(parentClsName) {\n\(propertiesText)\n\t\(clsName)(\(propertiesInitText!));\n\n\tfactory \(clsName).fromJson(Map<String, dynamic> srcJson) => _$\(clsName)FromJson(srcJson);\n\n\tMap<String, dynamic> toJson() => _$\(clsName)ToJson(this);\n\n}\n"
    }
    
    func fileSuffix() -> String {
        return "dart"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        var className = rootName
        let prefixStr = StringUtils.isEmpty(prefix) ? "" : "\(prefix!.lowercased())_"
        let importStr = "\nimport 'package:json_annotation/json_annotation.dart';\n\npart '\(prefixStr)\(className.humpToUnderline()).g.dart';\n"
        return importStr
    }
    
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export] {
        let prefix = StringUtils.isEmpty(config.prefix) ? "" : "\(config.prefix!.lowercased())_"
        let filePath = "\(path)/\(prefix)\(config.rootName.humpToUnderline()).\(fileSuffix())"
        return [Export(path: filePath, content: content)]
    }
}
