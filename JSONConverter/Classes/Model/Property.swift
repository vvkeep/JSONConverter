//
//  Property.swift
//  JSONConverter
//
//  Created by Yao on 2018/2/7.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation

class Property {
    var parentNodeName: String

    var className: String

    var keyName: String
    
    var type: PropertyType
    
    var langStruct: LangStruct
    
    var prefixStr: String?
    
    var autoCaseUnderline: Bool
    
    private var builder: BuilderProtocol!

    init(parentNodeName: String, keyName: String, type: PropertyType, langStruct: LangStruct, prefixStr: String?, autoCaseUnderline: Bool) {
        self.parentNodeName = parentNodeName
        self.keyName = keyName
        self.type = type
        self.langStruct = langStruct
        self.prefixStr = prefixStr
        self.autoCaseUnderline = autoCaseUnderline
        
        let tempPropertyKey = autoCaseUnderline ? keyName.underlineToHump() : keyName
        className = tempPropertyKey.className(withPrefix: prefixStr)
        if !parentNodeName.isEmpty {
            className = "\(parentNodeName)\(tempPropertyKey.uppercaseFirstChar())"
        }
        
        builder = JSONProcesser.shared.builder(lang: langStruct.langType)
    }
        
    func propertyString() -> String {
        let strategy: PropertyStrategy = autoCaseUnderline ? .underlineToHump : .origin
        let propertyStr = builder.propertyText(type, keyName: keyName, strategy: strategy, typeName: className)
        return propertyStr
    }
        
    func initString() -> String {
        let strategy: PropertyStrategy = autoCaseUnderline ? .underlineToHump : .origin
        let initStr = builder.initPropertyText(type, keyName: keyName, strategy: strategy, typeName: className)
        return initStr
    }
    
    func getterString() -> String {
        let strategy: PropertyStrategy = autoCaseUnderline ? .underlineToHump : .origin
        let getterStr = builder.propertyGetterText(type, keyName: keyName, strategy: strategy, typeName: className)
        return getterStr
    }
    
    func setterString() -> String {
        let strategy: PropertyStrategy = autoCaseUnderline ? .underlineToHump : .origin
        let setterStr = builder.propertySetterText(type, keyName: keyName, strategy: strategy, typeName: className)
        return setterStr
    }
}

extension Property: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyName)
        hasher.combine(type)
    }
    
    static func < (lhs: Property, rhs: Property) -> Bool {
        return lhs.keyName.localizedStandardCompare(rhs.keyName) == .orderedAscending
    }

    static func == (lhs: Property, rhs: Property) -> Bool {
        return lhs.keyName == rhs.keyName && lhs.type == rhs.type
    }
}
