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

enum PropertyType: Int {
    case `String` = 0
    case `Int`
    case `Float`
    case `Double`
    case `Bool`
    case `Dictionary`
    case ArrayString
    case ArrayInt
    case ArrayFloat
    case ArrayDouble
    case ArrayBool
    case ArrayDictionary
    case `nil` //  nil use string instead
    
    func typeName(_ langStruct: LangStruct) -> String {
        // TODO
        return ""
    }
}


class Property {
        
    var keyName: String
    
    var type: PropertyType
    
    var langStruct: LangStruct
    
    var prefixStr: String?
    
    var autoCaseUnderline: Bool
    
    var typeName: String
    
    init(propertyKey: String, type: PropertyType, langStruct: LangStruct, prefixStr: String?, autoCaseUnderline: Bool, typeName: String? = nil) {
        self.keyName = propertyKey
        self.type = type
        self.langStruct = langStruct
        self.prefixStr = prefixStr
        self.autoCaseUnderline = autoCaseUnderline
        self.typeName = typeName ?? type.typeName(langStruct)
    }
    
    func toString() -> (String, String){
        let tempPropertyKey = autoCaseUnderline ? keyName.underlineToHump() : keyName
        var propertyStr = ""
        var initStr = ""
        
        switch type {
        case .String:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(tempPropertyKey);\n"
            case .Swift,.HandyJSON, .Codable:
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
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) \(tempPropertyKey.className(withPrefix: prefixStr)) *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey): \(tempPropertyKey.className(withPrefix: prefixStr))?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey): \(tempPropertyKey.className(withPrefix: prefixStr))?\n"
                initStr = "\t\t\(tempPropertyKey) = \(tempPropertyKey.className(withPrefix: prefixStr))(json: json[\"\(keyName)\"])\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey): \(tempPropertyKey.className(withPrefix: prefixStr))?\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tMap<String,dynamic>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .ArrayString:
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
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
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<\(tempPropertyKey.className(withPrefix: prefixStr)) *> *\(tempPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(tempPropertyKey) = [\(tempPropertyKey.className(withPrefix: prefixStr))]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(tempPropertyKey) = [\(tempPropertyKey.className(withPrefix: prefixStr))]()\n"
                initStr = "\t\t\(tempPropertyKey) = json[\"\(keyName)\"].arrayValue.compactMap({ \(tempPropertyKey.className(withPrefix: prefixStr))(json: $0)})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(tempPropertyKey) = [\(tempPropertyKey.className(withPrefix: prefixStr))]()\n"
                initStr = "\t\t\(tempPropertyKey)\(currentMapperSpace)<- map[\"\(keyName)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(keyName)')\n\tList<\(tempPropertyKey.className(withPrefix: prefixStr))>? \(tempPropertyKey);\n"
                initStr = "this.\(tempPropertyKey),"
            }
        case .nil:
            switch langStruct.langType{
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
        }
        return (propertyStr, initStr)
    }
    
}

extension Property: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyName)
        hasher.combine(type)
    }
    
    static func < (lhs: Property, rhs:Property) -> Bool {
        return lhs.keyName.localizedStandardCompare(rhs.keyName) == .orderedAscending
    }

    static func == (lhs: Property, rhs:Property) -> Bool {
        return lhs.keyName == rhs.keyName && lhs.type == rhs.type
    }
}
