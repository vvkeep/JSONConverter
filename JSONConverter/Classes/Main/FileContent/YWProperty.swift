//
//  YWProperty.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

enum YWPropertyType {
    case `String`
    case `Int`
    case `Double`
    case `Bool`
    case `Array`
    case `Dictionary`
    case CustomObj
}


class YWProperty {
    var nativeName: String
    var jsonName: String
    var type: YWPropertyType
    
    init(nativeName: String, jsonName: String, type: YWPropertyType) {
        self.nativeName = nativeName
        self.jsonName = jsonName
        self.type = type
    }
    
    func toString() -> String {
        return ""
    }
}
