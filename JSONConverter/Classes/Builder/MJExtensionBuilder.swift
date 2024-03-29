//
//  MJExtensionBuilder.swift
//  JSONConverter
//
//  Created by yaow on 2022/5/11.
//  Copyright © 2022 vvkeep. All rights reserved.
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
        case .Float, .Double:
            return "@property (nonatomic, assign) CGFloat \(tempKeyName);\n"
        case .Bool:
            return "@property (nonatomic, assign) BOOL \(tempKeyName);\n"
        case .Dictionary:
            return "@property (nonatomic, strong) \(keyTypeName!) *\(tempKeyName);\n"
        case .ArrayString, .ArrayNull:
            return "@property (nonatomic, strong) NSArray<NSString *> *\(tempKeyName);\n"
        case .ArrayInt, .ArrayFloat, .ArrayDouble, .ArrayBool:
            return "@property (nonatomic, strong) NSArray<NSNumber *> *\(tempKeyName);\n"
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
    
    func contentImplText(_ content: Content, strategy: PropertyStrategy, useKeyMapper: Bool) -> String {
        let frontReturnText = "    return @{"
        
        var propertyMapperText = ""
        if useKeyMapper {
            let propertyMapperList = content.properties.enumerated().map { (index, property) -> String in
                let keyName = strategy.processed(property.keyName)
                let numSpace = index == 0 ? "" : String.numSpace(count: frontReturnText.count)
                return "\(numSpace)@\"\(property.keyName)\": @\"\(keyName)\""
            }
            
            propertyMapperText = """
                                 \n+ (NSDictionary *)mj_replacedKeyFromPropertyName {
                                 \(frontReturnText)\(propertyMapperList.joined(separator: ",\n"))};
                                 }\n
                                """
        }
        
        var firstArrayTypeFlag = true
        let arrayTypePropertyList = content.properties.compactMap { property -> String? in
            if property.type == .ArrayDictionary {
                let keyName = strategy.processed(property.keyName)
                let numSpace = String.numSpace(count: firstArrayTypeFlag ? 0 : frontReturnText.count)
                firstArrayTypeFlag = false
                return "\(numSpace)@\"\(keyName)\": [\(property.className) class]"
            } else {
                return nil
            }
        }
        
        var arrayPropertyText = ""
        if !arrayTypePropertyList.isEmpty {
            arrayPropertyText = """
                                \n+ (NSDictionary *)mj_objectClassInArray {
                                \(frontReturnText)\(arrayTypePropertyList.joined(separator: ",\n"))};
                                }\n
                                """
        }
        
        let result = """
                     \n@implementation \(content.className) \(propertyMapperText)\(arrayPropertyText)
                     @end\n
                     """
        return result
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
