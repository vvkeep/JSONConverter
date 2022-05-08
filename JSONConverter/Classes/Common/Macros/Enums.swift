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
    case KakaJSON
    case SwiftyJSON
    case ObjectMapper
    case Codable
    case ObjC
    case YYModel
    case Flutter
    case Java
    case Golang
    
    // the value is highlightr language
    var language: String! {
        switch self {
        case .Swift, .HandyJSON, .SwiftyJSON, .KakaJSON, .ObjectMapper, .Codable:
            return "swift"
        case .ObjC, .YYModel:
            return "objectivec"
        case .Flutter:
            return "dart"
        case .Java:
            return "java"
        case .Golang:
            return "golang"
        }
    }
        
    // the arrary index is enum LangType value
    static func languages() -> [String] {
        return ["Swift", "HandyJSON", "KakaJSON", "SwiftyJSON", "ObjectMapper", "Codable", "ObjC", "YYModel", "Flutter", "Java", "Golang"]
    }
    
    var onlyCompatibleClass: Bool {
        let compatibleLangList: [LangType] = [.ObjC, .YYModel, .Flutter]
        return compatibleLangList.contains(self)
    }
    
    var onlyCompatibleStruct: Bool {
        let compatibleLangList: [LangType] = [.Codable, .Golang]
        return compatibleLangList.contains(self)
    }
    
    var isDoubleClassFiles: Bool {
        let doubleClassFilesLangList: [LangType] = [.ObjC, .YYModel]
        return doubleClassFilesLangList.contains(self)
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
    
    func isDictionaryType() -> Bool {
        return self == .Dictionary || self == .ArrayDictionary
    }
}

enum PropertyStrategy {
    case origin
    case underlineToHump
    
    func processed(_ keyName: String) -> String {
        return self == .origin ? keyName : keyName.underlineToHump()
    }
}
