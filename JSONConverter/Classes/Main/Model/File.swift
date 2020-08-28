//
//  File.swift
//  JSONConverter
//
//  Created by Yao on 2018/2/7.
//  Copyright © 2018年 Ahmed Ali. All rights reserved.
//

import Foundation

class File {
    
    var header: String = ""
    
    var prefix: String = ""
    
    var parentName: String = ""
    
    var langStruct = LangStruct(langType: .Swift, structType: .struct)
        
    var contents = [Content]()
    
    var rootName: String = ""
    
    class func file(withName name: String, prefix: String, langStruct: LangStruct, parentName: String) -> File {
        let file = File()
        file.rootName = name
        file.prefix = prefix
        file.langStruct = langStruct
        file.parentName = parentName
        return file
    }
    
    class func cacheFile(withDic dic: [String: String]?) -> File {
        let file = File()
        file.header = dic?["header"] ?? ""
        file.rootName = dic?["rootName"] ?? "RootClass"
        file.prefix = dic?["prefix"] ?? ""
        file.parentName = dic?["parentName"] ?? ""
        
        let langIndex = Int(dic?["langType"] ?? "0")!
        let structIndex = Int(dic?["structType"] ?? "0")!
        let langType = LangType(rawValue: langIndex)!
        let structType = StructType(rawValue: structIndex)!
        let transStruct = LangStruct(langType: langType, structType: structType)
        file.langStruct = transStruct
        return file
    }
    
    func fileContent(withPropertyKey key: String) -> Content {
        let content = Content(propertyKey: key, langStruct: langStruct, superClass: parentName, prefixStr: prefix)
        return content
    }
    
    func fileProperty(withPropertykey key: String, type: YWPropertyType) -> Property {
        let property = Property(propertyKey: key, type: type, langStruct: langStruct, prefixStr: prefix)
        return property
    }
    
    func toString() -> String {
        var totalStr = ""
        if langStruct.langType == LangType.Flutter {
            var className = rootName.className(withPrefix: prefix);
            totalStr = "\nimport 'package:json_annotation/json_annotation.dart';\n\npart '\(className.underline()).g.dart';\n"
        }
        contents.forEach { (content) in
            totalStr += content.toString()
        }
        
        totalStr.removeFistChar()
        return totalStr
    }
    
    func toCacheConfig() -> Dictionary<String, Any> {
        return ["header": header, "rootName": rootName, "prefix": prefix, "parentName": parentName, "langType": "\(langStruct.langType.rawValue)", "structType": "\(langStruct.structType.rawValue)"]
    }
    
}

