//
//  JSONModelBuilder.swift
//  JSONConverter
//
//  Created by Sharker on 1/23/23.
//  Copyright © 2023 姚巍. All rights reserved.
//

import Cocoa

class JSONModelBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .JSONModel
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
            return "@property (nonatomic, strong) NSArray<\(keyTypeName!)> *\(tempKeyName);\n"
        }
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? ": JSONModel" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: String, propertiesInitText: String?, propertiesGetterSetterText: String?) -> String {
        let tempPropertiesText = StringUtils.removeLastChar(propertiesText)
        return "\n@interface \(clsName)\(parentClsName)\n\(tempPropertiesText)\n@end\n"
    }
    
    func contentImplText(_ content: Content, strategy: PropertyStrategy, useKeyMapper: Bool) -> String {
        let frontReturnText = "    NSDictionary *dict = @{"
        
        var propertyMapperText = ""
        if useKeyMapper {
            let propertyMapperList = content.properties.enumerated().map { (index, property) -> String in
                let keyName = strategy.processed(property.keyName)
                let numSpace = index == 0 ? "" : String.numSpace(count: frontReturnText.count)
                return "\(numSpace)@\"\(keyName)\": @\"\(property.keyName)\""
            }
            
            propertyMapperText = """
                                 \n+ (JSONKeyMapper*)keyMapper {
                                 \(frontReturnText)\(propertyMapperList.joined(separator: ",\n"))};\n
                                     return [[JSONKeyMapper alloc]initWithModelToJSONBlock:^NSString *(NSString *keyName) {
                                        return dict[keyName]?:keyName;
                                    }];
                                 }\n
                                """
        }
        
        //
        var propertyIsOptionalFunc = """
                                     \n+ (BOOL)propertyIsOptional:(NSString *)propertyName {
                                         return YES;
                                     }
                                     """
        
        let result = """
                     \n@implementation \(content.className) \(propertyMapperText)\(propertyIsOptionalFunc)
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
                    #import <JSONModel/JSONModel.h>\n
                    """
        for (i, content) in contents.enumerated() where i > 0 {
            let className = strategy.processed(content.className)
            tempStr += "\n@class \(className);"
        }
        
        tempStr += "\n"
        // jsonModel Protocol
        tempStr += fileImportProtocolText(contents: contents)
        return tempStr
    }
    
    func fileImportProtocolText(contents: [Content]) -> String {
        var tempStr = ""
        for (i, content) in contents.enumerated() where i > 0 {
            for property in content.properties {
                if property.type == .ArrayDictionary {
                    tempStr += "\n@protocol \(property.className);"
                }
            }
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
