//
//  YWContent.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
class YWContent {
    var properties = [YWProperty]()
    
    var propertyKey: String
    
    var langStruct: LangStruct
    
    var superClass: String
    
    var prefixStr: String
    
    init(propertyKey: String, langStruct: LangStruct, superClass: String, prefixStr: String) {
        self.propertyKey = propertyKey
        self.langStruct = langStruct
        self.superClass = superClass
        self.prefixStr = prefixStr
    }
    
    func toString() -> String {
        let className = propertyKey.className(withPrefix: prefixStr)
        var contentStr = ""
        
        let result = propertyPartAndIntPart()
        var propertyTotalPart = result.0
        let initSwiftTotalPart = result.1
        
        switch langStruct.langType {
        case .ObjC:
            propertyTotalPart.removeLastChar()
            contentStr = "\n@interface \(className)\(superClassNamePart())\n\(propertyTotalPart)\n@end\n"
        case .Swift:
            propertyTotalPart.removeLastChar()
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n}\n"
            }
        case .HandyJSON:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\trequired init() {}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n}\n"
            }
        case .SwiftyJSON:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\tinit(json: JSON) {\n\(initSwiftTotalPart)\t}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\tinit(json: JSON) {\n\(initSwiftTotalPart)\t}\n}\n"
            }
        case .ObjectMapper:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\trequired init?(map: Map) {}\n\n\tfunc mapping(map: Map) {\n\(initSwiftTotalPart)\t}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\tinit?(map: Map) {}\n\n\tmutating func mapping(map: Map) {\n\(initSwiftTotalPart)\t}\n}\n"
            }
        }
        
        return contentStr
    }
    
    private func propertyPartAndIntPart() -> (String, String) {
        var propertyStr = ""
        var initSwiftStr = ""

        properties.forEach({ (property) in
            let result = property.toString()
            propertyStr += result.0
            initSwiftStr += result.1
        })
        
        return (propertyStr, initSwiftStr)
    }
    
    private func superClassNamePart() -> String {
        var superClassPart: String = ""
        
        switch langStruct.langType {
        case .HandyJSON:
            superClassPart = superClass.isEmpty ? ": HandyJSON" : ": \(superClass)"
        case .Swift, .SwiftyJSON:
            superClassPart = superClass.isEmpty ? "" : ": \(superClass)"
        case .ObjC:
            superClassPart = superClass.isEmpty ? ": NSObject" : ": \(superClass)"
        case .ObjectMapper:
            superClassPart = superClass.isEmpty ? ": Mappable" : ": \(superClass)"
            break
        }
        
        return superClassPart
    }
}
