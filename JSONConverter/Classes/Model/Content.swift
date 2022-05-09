//
//  YWContent.swift
//  JSONConverter
//
//  Created by Yao on 2018/2/7.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation

class Content {
    var properties = [Property]()
    
    var parentNodeName: String
    
    var className: String
    
    var keyName: String
    
    var langStruct: LangStruct
    
    var parentClsName: String?
    
    var prefix: String?
    
    var autoCaseUnderline: Bool
    
    private var builder: BuilderProtocol!
    
    init(parentNodeName: String, keyName: String, langStruct: LangStruct, parentClsName: String?, prefixStr: String?, autoCaseUnderline: Bool) {
        self.parentNodeName = parentNodeName
        self.keyName = keyName
        self.langStruct = langStruct
        self.parentClsName = parentClsName
        self.prefix = prefixStr
        self.autoCaseUnderline = autoCaseUnderline
        
        let tempPropertyKey = autoCaseUnderline ? keyName.underlineToHump() : keyName
        className = tempPropertyKey.className(withPrefix: prefixStr)
        if StringUtils.isNotEmpty(parentNodeName) {
            className = "\(parentNodeName)\(tempPropertyKey.uppercaseFirstChar())"
        }
        
        self.builder = JSONProcesser.shared.builder(lang: langStruct.langType)
    }
    
    func toContentClassString() -> String {
        properties.sort { $0 < $1 }
        let propertiesText = allPropertyString()
        let propertiesInitText: String? = allPropertyInitString()
        let parentClsName = builder.contentParentClassText(self.parentClsName)
        let propertiesGetterSetterText: String? = allGetterSetterString()
        
        let contentText = builder.contentText(langStruct.structType, clsName: className, parentClsName: parentClsName, propertiesText: propertiesText, propertiesInitText: propertiesInitText, propertiesGetterSetterText: propertiesGetterSetterText)
        return contentText
    }
}

extension Content {
    private func allPropertyString() -> String {
        var propertyStr = ""
        let max = properties.map({ $0.type.isDictionaryType() ? $0.className.count : $0.keyName.count }).max() ?? 0
        properties.forEach { property in
            propertyStr += property.propertyString(max)
        }
        return propertyStr
    }
    
    private func allPropertyInitString() -> String {
        var initStr = ""
        let max = properties.map({ $0.keyName.count }).max() ?? 0
        properties.forEach { property in
            initStr += property.initString(max)
        }
        return initStr
    }
    
    private func allGetterSetterString() -> String {
        var str = ""
        properties.forEach { property in
            str += property.getterString()
            str += property.setterString()
        }
        return str
    }
}

extension Content: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyName)
        hasher.combine(parentClsName)
        hasher.combine(properties)
    }
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        if lhs.properties.count == rhs.properties.count {
            let result = Set(arrayLiteral: lhs.properties).symmetricDifference(Set(arrayLiteral: rhs.properties))
            return result.count == 0
        } else {
            return false
        }
    }
}
