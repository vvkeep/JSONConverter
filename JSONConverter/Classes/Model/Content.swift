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
    
    var prefixStr: String?
    
    var autoCaseUnderline: Bool
    
    init(parentNodeName: String, keyName: String, langStruct: LangStruct, parentClsName: String?, prefixStr: String?, autoCaseUnderline: Bool) {
        self.parentNodeName = parentNodeName
        self.keyName = keyName
        self.langStruct = langStruct
        self.parentClsName = parentClsName
        self.prefixStr = prefixStr
        self.autoCaseUnderline = autoCaseUnderline
        
        let tempPropertyKey = autoCaseUnderline ? keyName.underlineToHump() : keyName
        className = tempPropertyKey.className(withPrefix: prefixStr)
        if !parentNodeName.isEmpty {
            className = "\(parentNodeName)\(tempPropertyKey.uppercaseFirstChar())"
        }
    }
    
    func toString() -> String {
        var contentStr = ""
        
        let result = constructPropertyAndSetup()
        var propertyTotalPart = result.0
        let initTotalPart = result.1
        
        switch langStruct.langType {
        case .ObjC:
            propertyTotalPart.removeLastChar()
            contentStr = "\n@interface \(className)\(constructParentClassName())\n\(propertyTotalPart)\n@end\n"
        case .Swift:
            propertyTotalPart.removeLastChar()
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n}\n"
            } else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n}\n"
            }
        case .HandyJSON, .Codable:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n\trequired init() {}\n}\n"
            } else if langStruct.structType == .struct {
                propertyTotalPart.removeLastChar()
                contentStr = "\nstruct \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n}\n"
            }
        case .SwiftyJSON:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n\tinit(json: JSON) {\n\(initTotalPart)\t}\n}\n"
            } else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n\tinit(json: JSON) {\n\(initTotalPart)\t}\n}\n"
            }
        case .ObjectMapper:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n\trequired init?(map: Map) {}\n\n\tfunc mapping(map: Map) {\n\(initTotalPart)\t}\n}\n"
            } else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n\tinit?(map: Map) {}\n\n\tmutating func mapping(map: Map) {\n\(initTotalPart)\t}\n}\n"
            }
        case .Flutter:
            contentStr = "\n@JsonSerializable()\nclass \(className)\(constructParentClassName()) {\n\(propertyTotalPart)\n\t\(className)(\(initTotalPart));\n\n\tfactory \(className).fromJson(Map<String, dynamic> srcJson) => _$\(className)FromJson(srcJson);\n\n\tMap<String, dynamic> toJson() => _$\(className)ToJson(this);\n\n}\n"
        }
        
        return contentStr
    }
    
    private func constructPropertyAndSetup() -> (String, String) {
        var propertyStr = ""
        var setupStr = ""
        
        properties.sort { $0 < $1 }
        properties.forEach({ (property) in
            let result = property.toString()
            propertyStr += result.0
            setupStr += result.1
        })
        
        return (propertyStr, setupStr)
    }
    
    private func constructParentClassName() -> String {
        var parentClsNamePart: String = ""
        
        switch langStruct.langType {
        case .HandyJSON:
            parentClsNamePart = StringUtils.isBlank(parentClsName) ? ": HandyJSON" : ": \(parentClsName!)"
        case .Swift, .SwiftyJSON:
            parentClsNamePart = StringUtils.isBlank(parentClsName) ? "" : ": \(parentClsName!)"
        case .ObjC:
            parentClsNamePart = StringUtils.isBlank(parentClsName) ? ": NSObject" : ": \(parentClsName!)"
        case .ObjectMapper:
            parentClsNamePart = StringUtils.isBlank(parentClsName) ? ": Mappable" : ": \(parentClsName!)"
        case .Flutter:
            parentClsNamePart = StringUtils.isBlank(parentClsName) ? " extends Object" : " extends \(parentClsName!)"
        case .Codable:
            parentClsNamePart = StringUtils.isBlank(parentClsName) ? ": Codable" : ": \(parentClsName!)"
        }
        
        return parentClsNamePart
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
