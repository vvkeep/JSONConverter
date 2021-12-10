//
//  FlutterPropertyBuilder.swift
//  JSONConverter
//
//  Created by DevYao on 2021/12/9.
//  Copyright © 2021 姚巍. All rights reserved.
//

import Foundation

class FlutterPropertyBuilder: PropertyBuildProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .Flutter
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        assert((type == .Dictionary || type == .ArrayDictionary) && typeName != nil, " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tString? \(tempKeyName);\n"
        case .Int:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tint? \(tempKeyName);\n"
        case .Float:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tdouble? \(tempKeyName);\n"
        case .Double:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tdouble? \(tempKeyName);\n"
        case .Bool:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tbool? \(tempKeyName);\n"
        case .Dictionary:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tMap<String,dynamic>? \(tempKeyName);\n"
        case .ArrayString, .ArrayNull:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<String>? \(tempKeyName);\n"
        case .ArrayInt:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<int>? \(tempKeyName);\n"
        case .ArrayFloat:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<double>? \(tempKeyName);\n"
        case .ArrayDouble:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<double>? \(tempKeyName);\n"
        case .ArrayBool:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<bool>? \(tempKeyName);\n"
        case .ArrayDictionary:
            return "\n\t@JsonKey(name: '\(keyName)')\n\tList<\(typeName!)>? \(tempKeyName);\n"
        }
    }
    
    func initText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        let tempKeyName = strategy.processed(keyName)
        return "this.\(tempKeyName),"
    }
}
