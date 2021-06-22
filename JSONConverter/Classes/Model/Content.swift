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
    
    var propertyKey: String
    
    var langStruct: LangStruct
    
    var parentClsName: String?
    
    var prefixStr: String?
    
    init(propertyKey: String, langStruct: LangStruct, parentClsName: String?, prefixStr: String?) {
        self.propertyKey = propertyKey
        self.langStruct = langStruct
        self.parentClsName = parentClsName
        self.prefixStr = prefixStr
    }
    
    func toString() -> String {
        let className = propertyKey.convertFromSnakeCase().className(withPrefix: prefixStr)
        var contentStr = ""
        
        let result = propertyAndInitPart()
        var propertyTotalPart = result.0
        let initTotalPart = result.1
        
        switch langStruct.langType {
        case .ObjC:
            propertyTotalPart.removeLastChar()
            contentStr = "\n@interface \(className)\(parentClsNameNamePart())\n\(propertyTotalPart)\n@end\n"
        case .Swift:
            propertyTotalPart.removeLastChar()
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n}\n"
            }
        case .HandyJSON, .Codable:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n\trequired init() {}\n}\n"
            }else if langStruct.structType == .struct {
                propertyTotalPart.removeLastChar()
                contentStr = "\nstruct \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n}\n"
            }
        case .SwiftyJSON:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n\tinit(json: JSON) {\n\(initTotalPart)\t}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n\tinit(json: JSON) {\n\(initTotalPart)\t}\n}\n"
            }
        case .ObjectMapper:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n\trequired init?(map: Map) {}\n\n\tfunc mapping(map: Map) {\n\(initTotalPart)\t}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n\tinit?(map: Map) {}\n\n\tmutating func mapping(map: Map) {\n\(initTotalPart)\t}\n}\n"
            }
        case .Flutter:
            contentStr = "\n@JsonSerializable()\nclass \(className)\(parentClsNameNamePart()) {\n\(propertyTotalPart)\n\t\(className)(\(initTotalPart));\n\n\tfactory \(className).fromJson(Map<String, dynamic> srcJson) => _$\(className)FromJson(srcJson);\n\n\tMap<String, dynamic> toJson() => _$\(className)ToJson(this);\n\n}\n"
        }
        
        return contentStr
    }
    
    private func propertyAndInitPart() -> (String, String) {
        var propertyStr = ""
        var initSwiftStr = ""
        
        properties.sort{ $0 < $1 }
        properties.forEach({ (property) in
            let result = property.toString()
            propertyStr += result.0
            initSwiftStr += result.1
        })
        
        return (propertyStr, initSwiftStr)
    }
    
    private func parentClsNameNamePart() -> String {
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

func < (lhs: Content, rhs:Content) -> Bool {
    return lhs.propertyKey.localizedStandardCompare(rhs.propertyKey) == .orderedAscending
}
