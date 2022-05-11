//
//  MJExtensionBuilder.swift
//  JSONConverter
//
//  Created by yaow on 2022/5/11.
//  Copyright © 2022 姚巍. All rights reserved.
//

import Foundation

class MJExtensionBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .MJExtension
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
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
            return "@property (nonatomic, strong) \(keyTypeName!) *\(tempKeyName);\n"
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
            return "@property (nonatomic, strong) NSArray<\(keyTypeName!) *> *\(tempKeyName);\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
       return StringUtils.isEmpty(clsText) ? ": NSObject" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: String, propertiesInitText: String?, propertiesGetterSetterText: String?) -> String {
        let tempPropertiesText = StringUtils.removeLastChar(propertiesText)
        return "\n@interface \(clsName)\(parentClsName)\n\(tempPropertiesText)\n@end\n"
    }
    
    func contentImplText(_ content: Content, strategy: PropertyStrategy) -> String {
        let frontReturnText = "    return @{"
        let propertyMapperText = content.properties.enumerated().map { (index, property) in
            let keyName = strategy.processed(property.keyName)
            let numSpace = index == 0 ? "" : String.numSpace(count: frontReturnText.count)
            return "\(numSpace)\"@\(property.keyName)\": \"@\(keyName)\""
        }.joined(separator: ",\n")
        
        var firstArrayTypeFlag = true
        let containerPropertyText = content.properties.compactMap { (property) in
            if property.type == .ArrayDictionary {
                let keyName = strategy.processed(property.keyName)
                let numSpace = String.numSpace(count: firstArrayTypeFlag ? 0 : frontReturnText.count)
                firstArrayTypeFlag = false
                return "\(numSpace)\"@\(keyName)\": [\(property.className) class]"
            } else {
                return nil
            }
        }.joined(separator: ",\n")
                
        let text = """
                 \n@implementation \(content.className)
                 + (NSDictionary *)mj_replacedKeyFromPropertyName {
                 \(frontReturnText)\(propertyMapperText)}
                 }
                 
                 + (NSDictionary *)mj_objectClassInArray {
                 \(frontReturnText)\(containerPropertyText)}
                 }
                 @end\n
                 """
        return text
    }

    func fileSuffix() -> String {
        return "h"
    }
    
    func fileImplSuffix() -> String {
        return "m"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        var tempStr = """
                    \n#import <Foundation/Foundation.h>
                    #import <MJExtension/MJExtension.h>\n
                    """
        for (i, content) in contents.enumerated() where i > 0 {
            let className = strategy.processed(content.className)
            tempStr += "\n@class \(className);"
        }
        
        tempStr += "\n"
        return tempStr
    }
    
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export] {
        let filePath = "\(path)/\(config.rootName.className(withPrefix: config.prefix))"
        return [Export(path: "\(filePath).\(fileSuffix())", content: content), Export(path: "\(filePath).\(fileImplSuffix())", content: classImplContent!)]
    }
    
    func fileImplText(_ header: String, rootName: String, prefix: String?, contentCustomPropertyMapperTexts: [String]) -> String {
        var temp = header
        let rootClsName = rootName.className(withPrefix: prefix)
        temp += "\n#import \"\(rootClsName).h\"\n"

        for item in contentCustomPropertyMapperTexts {
            temp += item
        }
        
        return temp
    }
}
