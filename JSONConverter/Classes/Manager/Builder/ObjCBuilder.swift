//
//  ObjCBuilder.swift
//  JSONConverter
//
//  Created by Yao on 2021/12/8.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation
class ObjCBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .ObjC
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && typeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "@property (nonatomic, copy) NSString *\(tempKeyName);\n"
        case .Int:
            return "@property (nonatomic, assign) NSInteger \(tempKeyName);\n"
        case .Float:
            return "@property (nonatomic, assign) Float \(tempKeyName);\n"
        case .Double:
            return "@property (nonatomic, assign) Double \(tempKeyName);\n"
        case .Bool:
            return "@property (nonatomic, assign) BOOL \(tempKeyName);\n"
        case .Dictionary:
            return "@property (nonatomic, strong) \(typeName!) *\(tempKeyName);\n"
        case .ArrayString, .ArrayNull:
            return "@property (nonatomic, strong) NSArray<NSString *> *\(tempKeyName);\n"
        case .ArrayInt:
            return "@property (nonatomic, strong) NSArray<Int> *\(tempKeyName);\n"
        case .ArrayFloat:
            return "@property (nonatomic, strong) NSArray<Float> *\(tempKeyName);\n"
        case .ArrayDouble:
            return "@property (nonatomic, strong) NSArray<Double> *\(tempKeyName);\n"
        case .ArrayBool:
            return "@property (nonatomic, strong) NSArray<Bool> *\(tempKeyName);\n"
        case .ArrayDictionary:
            return "@property (nonatomic, strong) NSArray<\(typeName!) *> *\(tempKeyName);\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
       return StringUtils.isEmpty(clsText) ? ": NSObject" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: inout String, propertiesInitText: inout String?) -> String {
        propertiesText.removeLastChar()
        return "\n@interface \(clsName)\(parentClsName)\n\(propertiesText)\n@end\n"
    }
}
