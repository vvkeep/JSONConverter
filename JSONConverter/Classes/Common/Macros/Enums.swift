//
//  Enums.swift
//  JSONConverter
//
//  Created by DevYao on 2020/9/9.
//  Copyright © 2020 DevYao. All rights reserved.
//

import Foundation

enum LangType: Int {
    case Swift = 0
    case HandyJSON
    case SwiftyJSON
    case ObjectMapper
    case ObjC
    case Flutter
    case Codable
    case Java
    
    var language: String! {
        switch self {
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper, .Codable:
            return "swift"
        case .ObjC:
            return "objectivec"
        case .Flutter:
            return "dart"
        case .Java:
            return "java"
        }
    }
    
    static func languages() -> [String] {
        return ["Swift", "HandyJSON", "SwiftyJSON", "ObjectMapper", "ObjC", "Flutter", "Codable", "Java"]
    }
}

enum StructType: Int {
    case `struct` = 0
    case `class`
    
    static func strusts() -> [String] {
        return ["Struct", "Class"]
    }
}

struct LangStruct {
    var langType: LangType
    var structType: StructType
    
    init(langType: LangType, structType: StructType) {
        self.langType = langType
        self.structType = structType
    }
}

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
    case ArrayNull // array no element, use ArrayString instead
    case Null //  nil use `String` instead
    
    func arrayWrapperType() -> PropertyType {
        if self.rawValue >= 0 && self.rawValue <= 5 {
            return PropertyType(rawValue: self.rawValue + 6)!
        } else {
            return .Null
        }
    }
}

enum PropertyStrategy {
    case origin
    case underlineToHump
    
    func processed(_ keyName: String) -> String {
        return self == .origin ? keyName : keyName.underlineToHump()
    }
}
