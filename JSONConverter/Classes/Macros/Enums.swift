//
//  Enums.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/9/9.
//  Copyright © 2020 姚巍. All rights reserved.
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
    
    var suffix: String {
        switch self {
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper, .Codable:
            return "swift"
        case .ObjC:
            return "h"
        case .Flutter:
            return "dart"
        }
    }
}

enum StructType: Int {
    case `struct` = 0
    case `class`
}

struct LangStruct {
    var langType: LangType
    var structType: StructType
    
    init(langType: LangType, structType: StructType) {
        self.langType = langType
        self.structType = structType
    }
}
