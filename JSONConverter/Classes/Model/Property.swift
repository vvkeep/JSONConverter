//
//  Property.swift
//  JSONConverter
//
//  Created by Yao on 2018/2/7.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation

/// count = 3
let currentMapperSpace = "   "

class Property {
    var parentNodeName: String

    var className: String

    var keyName: String
    
    var type: PropertyType
    
    var langStruct: LangStruct
    
    var prefixStr: String?
    
    var autoCaseUnderline: Bool
        
    init(parentNodeName: String, keyName: String, type: PropertyType, langStruct: LangStruct, prefixStr: String?, autoCaseUnderline: Bool) {
        self.parentNodeName = parentNodeName
        self.keyName = keyName
        self.type = type
        self.langStruct = langStruct
        self.prefixStr = prefixStr
        self.autoCaseUnderline = autoCaseUnderline
        
        let tempPropertyKey = autoCaseUnderline ? keyName.underlineToHump() : keyName
        className = tempPropertyKey.className(withPrefix: prefixStr)
        if !parentNodeName.isEmpty {
            className = "\(parentNodeName)\(tempPropertyKey.uppercaseFirstChar())"
        }
    }
    
    func toString() -> (String, String) {
        let tempPropertyKey = autoCaseUnderline ? keyName.underlineToHump() : keyName
        var propertyStr = ""
        var initStr = ""
        
        switch type {
        case .String, .Null:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): String\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): String?\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tString? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .Int:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) NSInteger \(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): Int = 0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): Int = 0\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].intValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): Int = 0\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tint? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .Float:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Float \(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): Float = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): Float = 0.0\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].floatValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): Float = 0.0\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tdouble? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .Double:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Double \(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): Double = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): Double = 0.0\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].doubleValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): Double = 0.0\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tdouble? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .Bool:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) BOOL \(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): Bool = false\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): Bool = false\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].boolValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): Bool = false\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tbool? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .Dictionary:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) \(className) *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): \(className)?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): \(className)\n"
                initStr = "\t\t\(tempPropertyKey) = \(className)(json: json[\"\(keyName)\"])\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): \(className)?\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tMap<String,dynamic>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayString, .ArrayNull:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<NSString *> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [String]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [String]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({$0.stringValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [String]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<String>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayInt:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Int> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [Int]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [Int]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({$0.intValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [Int]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<int>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayFloat:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Float> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [Float]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [Float]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({$0.floatValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [Float]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<double>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayDouble:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Double> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [Double]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [Double]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({$0.doubleValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [Double]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<double>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayBool:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Bool> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [Bool]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [Bool]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({$0.boolValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [Bool]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<bool>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayDictionary:
            switch langStruct.langType {
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<\(className) *> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [\(className)]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [\(className)]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({ \(className)(json: $0)})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [\(className)]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<\(className)>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        }
        return (propertyStr, initStr)
    }
}

extension Property: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyName)
        hasher.combine(type)
    }
    
    static func < (lhs: Property, rhs: Property) -> Bool {
        return lhs.keyName.localizedStandardCompare(rhs.keyName) == .orderedAscending
    }

    static func == (lhs: Property, rhs: Property) -> Bool {
        return lhs.keyName == rhs.keyName && lhs.type == rhs.type
    }
}
