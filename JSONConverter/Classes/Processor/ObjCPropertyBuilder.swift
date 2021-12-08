//
//  ObjCPropertyBuilder.swift
//  JSONConverter
//
//  Created by 姚巍 on 2021/12/8.
//  Copyright © 2021 姚巍. All rights reserved.
//

import Foundation
class ObjCPropertyBuilder: PropertyBuildProtocol {
    
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .ObjC
    }
    
    func propertyText(_ type: PropertyType, keyName: String, typeName: String?) -> String {
        assert((type == .Dictionary || type == .ArrayDictionary) && typeName != nil, " Dictonary type the typeName can not be nil")
        switch type {
        case .String, .null:
            return "@property (nonatomic, copy) NSString *\(keyName);\n"
        case .Int:
            return "@property (nonatomic, assign) NSInteger \(keyName);\n"
        case .Float:
            return "@property (nonatomic, assign) Float \(keyName);\n"
        case .Double:
            return "@property (nonatomic, assign) Double \(keyName);\n"
        case .Bool:
            return "@property (nonatomic, assign) BOOL \(keyName);\n"
        case .Dictionary:
            return "@property (nonatomic, strong) \(typeName!) *\(keyName);\n"
        case .ArrayString, .ArrayNull:
            return "@property (nonatomic, strong) NSArray<NSString *> *\(keyName);\n"
        case .ArrayInt:
            return "@property (nonatomic, strong) NSArray<Int> *\(keyName);\n"
        case .ArrayFloat:
            return "@property (nonatomic, strong) NSArray<Float> *\(keyName);\n"
        case .ArrayDouble:
            return "@property (nonatomic, strong) NSArray<Double> *\(keyName);\n"
        case .ArrayBool:
            return "@property (nonatomic, strong) NSArray<Bool> *\(keyName);\n"
        case .ArrayDictionary:
            return "@property (nonatomic, strong) NSArray<\(typeName!) *> *\(keyName);\n"
        }
    }
}
