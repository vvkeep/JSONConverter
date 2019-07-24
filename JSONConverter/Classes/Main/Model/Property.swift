//
//  Property.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

/// count = 3
let currentMapperSpace = "   "

enum YWPropertyType: Int {
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
    
    var propertyKey: String
    
    var type: YWPropertyType
    
    var langStruct: LangStruct
    
    var prefixStr: String
    
    init(propertyKey: String, type: YWPropertyType, langStruct: LangStruct, prefixStr: String) {
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
                propertyStr = "@property (nonatomic, copy) NSString *\(propertyKey);\n"
            case .Swift,.HandyJSON:
                propertyStr = "\tvar \(propertyKey): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): String?\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): String?\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tString \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .Int:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) NSInteger \(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey): Int = 0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): Int = 0\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].intValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): Int = 0\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tint \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .Float:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Float \(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey): Float = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): Float = 0.0\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].floatValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): Float = 0.0\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tdouble \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .Double:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Double \(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey): Double = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): Double = 0.0\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].doubleValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): Double = 0.0\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tdouble \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .Bool:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) BOOL \(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey): Bool = false\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): Bool = false\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].boolValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): Bool = false\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tbool \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .Dictionary:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) \(propertyKey.className(withPrefix: prefixStr)) *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey): \(propertyKey.className(withPrefix: prefixStr))?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): \(propertyKey.className(withPrefix: prefixStr))?\n"
                initStr = "\t\t\(propertyKey) = \(propertyKey.className(withPrefix: prefixStr))(json: json[\"\(propertyKey)\"])\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): \(propertyKey.className(withPrefix: prefixStr))?\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tMap<String,dynamic> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .ArrayString:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<NSString *> *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey) = [String]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey) = [String]()\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].arrayValue.flatMap({$0.stringValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey) = [String]()\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<String> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .ArrayInt:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Int> *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey) = [Int]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey) = [Int]()\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].arrayValue.flatMap({$0.intValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey) = [Int]()\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<int> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .ArrayFloat:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Float> *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey) = [Float]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey) = [Float]()\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].arrayValue.flatMap({$0.floatValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey) = [Float]()\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<double> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .ArrayDouble:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Double> *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey) = [Double]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey) = [Double]()\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].arrayValue.flatMap({$0.doubleValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey) = [Double]()\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<double> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .ArrayBool:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Bool> *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey) = [Bool]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey) = [Bool]()\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].arrayValue.flatMap({$0.boolValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey) = [Bool]()\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<bool> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .ArrayDictionary:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<\(propertyKey.className(withPrefix: prefixStr)) *> *\(propertyKey);\n"
            case .Swift, .HandyJSON:
                propertyStr = "\tvar \(propertyKey) = [\(propertyKey.className(withPrefix: prefixStr))]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey) = [\(propertyKey.className(withPrefix: prefixStr))]()\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].arrayValue.flatMap({ \(propertyKey.className(withPrefix: prefixStr))(json: $0)})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey) = [\(propertyKey.className(withPrefix: prefixStr))]()\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<\(propertyKey.className(withPrefix: prefixStr))> \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }
        case .nil:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(propertyKey);\n"
            case .Swift,.HandyJSON:
                propertyStr = "\tvar \(propertyKey): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKey): String?\n"
                initStr = "\t\t\(propertyKey) = json[\"\(propertyKey)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKey): String?\n"
                initStr = "\t\t\(propertyKey)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tString \(propertyKey);\n"
                initStr = "this.\(propertyKey),"
            }

        }
        
        return (propertyStr, initStr)
    }
    
}
