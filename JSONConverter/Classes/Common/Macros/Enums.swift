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
    case Swift_YYModel
    case ObjC
    case YYModel
    case MJExtension
    case JSONModel
    case Flutter
    case Java
    case Golang
    
    // the value is highlightr language
    var language: String! {
        switch self {
        case .Swift, .HandyJSON, .SwiftyJSON, .KakaJSON, .ObjectMapper, .Codable, .Swift_YYModel:
            return "swift"
        case .ObjC, .YYModel, .MJExtension, .JSONModel:
            return "objectivec"
        case .Flutter:
            return "dart"
        case .Java:
            return "java"
        case .Golang:
            return "golang"
        }
    }
    
    var title: String {
        switch self {
        case .Swift:
            return "Swift"
        case .HandyJSON:
            return "Swift - HandyJSON"
        case .SwiftyJSON:
            return "Swift - SwiftyJSON"
        case .KakaJSON:
            return "Swift - KakaJSON"
        case .ObjectMapper:
            return "Swift - ObjectMapper"
        case .Codable:
            return "Swift - Codable"
        case .Swift_YYModel:
            return "Swift - YYModel"
        case .ObjC:
            return "ObjectiveC"
        case .YYModel:
            return "ObjectiveC - YYModel"
        case .MJExtension:
            return "ObjectiveC - MJExtension"
        case .JSONModel:
            return "ObjectiveC - JSONModel"
        case .Flutter:
            return "Flutter - json_serializable"
        case .Java:
            return "Java"
        case .Golang:
            return "Golang"
        }
    }
    
    static func allValues() -> [LangType] {
        return [.Swift, .HandyJSON, .KakaJSON, .SwiftyJSON, .ObjectMapper, .Codable, .Swift_YYModel, .ObjC, .YYModel, .MJExtension, .JSONModel, .Flutter, .Java, .Golang]
    }
    
    var onlyCompatibleClass: Bool {
        let compatibleLangList: [LangType] = [.ObjC, .YYModel, .Swift_YYModel, .MJExtension, .Flutter]
        return compatibleLangList.contains(self)
    }
    
    var onlyCompatibleStruct: Bool {
        let compatibleLangList: [LangType] = [.Codable, .Golang]
        return compatibleLangList.contains(self)
    }
    
    var isDoubleClassFiles: Bool {
        let doubleClassFilesLangList: [LangType] = [.ObjC, .YYModel, .MJExtension, .JSONModel]
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
