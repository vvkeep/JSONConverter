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
    case `nil` // 目前 nil 的属性 使用 string 类型来替代
}


class Property {
    
    var humpPropertyKey: String
    
    var propertyKey: String
    
    var type: PropertyType
    
    var langStruct: LangStruct
    
    var prefixStr: String?
    
    init(propertyKey: String, type: PropertyType, langStruct: LangStruct, prefixStr: String?) {
        self.humpPropertyKey = propertyKey.convertFromSnakeCase()
        self.propertyKey = propertyKey
        self.type = type
        self.langStruct = langStruct
        self.prefixStr = prefixStr
    }
    
    func toString() -> (String, String){
        var propertyStr = ""
        var initStr = ""
        switch type {
        case .String:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(humpPropertyKey);\n"
            case .Swift,.HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): String?\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): String?\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tString \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .Int:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) NSInteger \(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): Int = 0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): Int = 0\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].intValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): Int = 0\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tint \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .Float:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Float \(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): Float = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): Float = 0.0\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].floatValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): Float = 0.0\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tdouble \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .Double:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Double \(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): Double = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): Double = 0.0\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].doubleValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): Double = 0.0\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tdouble \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .Bool:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) BOOL \(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): Bool = false\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): Bool = false\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].boolValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): Bool = false\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tbool \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .Dictionary:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) \(humpPropertyKey.className(withPrefix: prefixStr)) *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): \(humpPropertyKey.className(withPrefix: prefixStr))?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): \(humpPropertyKey.className(withPrefix: prefixStr))?\n"
                initStr = "\t\t\(humpPropertyKey) = \(humpPropertyKey.className(withPrefix: prefixStr))(json: json[\"\(propertyKey)\"])\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): \(humpPropertyKey.className(withPrefix: prefixStr))?\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tMap<String,dynamic> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .ArrayString:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<NSString *> *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey) = [String]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey) = [String]()\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].arrayValue.compactMap({$0.stringValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey) = [String]()\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<String> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .ArrayInt:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Int> *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey) = [Int]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey) = [Int]()\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].arrayValue.compactMap({$0.intValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey) = [Int]()\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<int> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .ArrayFloat:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Float> *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey) = [Float]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey) = [Float]()\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].arrayValue.compactMap({$0.floatValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey) = [Float]()\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<double> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .ArrayDouble:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Double> *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey) = [Double]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey) = [Double]()\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].arrayValue.compactMap({$0.doubleValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey) = [Double]()\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<double> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .ArrayBool:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Bool> *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey) = [Bool]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey) = [Bool]()\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].arrayValue.compactMap({$0.boolValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey) = [Bool]()\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<bool> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .ArrayDictionary:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<\(humpPropertyKey.className(withPrefix: prefixStr)) *> *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey) = [\(humpPropertyKey.className(withPrefix: prefixStr))]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey) = [\(humpPropertyKey.className(withPrefix: prefixStr))]()\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].arrayValue.compactMap({ \(humpPropertyKey.className(withPrefix: prefixStr))(json: $0)})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey) = [\(humpPropertyKey.className(withPrefix: prefixStr))]()\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<\(humpPropertyKey.className(withPrefix: prefixStr))> \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        case .nil:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(humpPropertyKey);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(humpPropertyKey): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(humpPropertyKey): String?\n"
                initStr = "\t\t\(humpPropertyKey) = json[\"\(propertyKey)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(humpPropertyKey): String?\n"
                initStr = "\t\t\(humpPropertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tString \(humpPropertyKey);\n"
                initStr = "this.\(humpPropertyKey),"
            }
        }
        return (propertyStr, initStr)
    }
}

func < (lhs: Property, rhs:Property) -> Bool {
    return lhs.propertyKey.localizedStandardCompare(rhs.propertyKey) == .orderedAscending
}
