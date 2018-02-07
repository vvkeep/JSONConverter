//
//  YWProperty.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

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
}


class YWProperty {
    
    var propertyKey: String
    
    var type: YWPropertyType
    
    var langStruct: LangStruct
    
    init(propertyKey: String, type: YWPropertyType, langStruct: LangStruct) {
        self.propertyKey = propertyKey
        self.type = type
        self.langStruct = langStruct
    }
    
    func toString() -> String {
        return ""
    }
}
