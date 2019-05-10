//
//  YWFile.swift
//  JSONExport
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 Ahmed Ali. All rights reserved.
//

import Foundation

class YWFile {
    
    var prefix: String = ""
    
    var superName: String = ""
    
    var langStruct = LangStruct(langType: .Swift, structType: .struct)
        
    var contents = [YWContent]()
    
    var rootName: String = ""
    
    class func file(withName name: String, prefix: String, langStruct: LangStruct, superName: String) -> YWFile {
        let file = YWFile()
        file.rootName = name
        file.prefix = prefix
        file.langStruct = langStruct
        file.superName = superName
        return file
    }
    
    class func cacheFile(withDic dic: [String: String]) -> YWFile {
        let file = YWFile()
        file.rootName = dic["rootName"] ?? ""
        file.prefix = dic["prefix"] ?? ""
        file.superName = dic["superName"] ?? ""
        
        let langIndex = Int(dic["langType"] ?? "0")!
        let structIndex = Int(dic["structType"] ?? "0")!
        let langTypeType = LangType(rawValue: langIndex)!
        let structType = StructType(rawValue: structIndex)!
        let transStruct = LangStruct(langType: langTypeType, structType: structType)
        file.langStruct = transStruct
        return file
    }
    
    func fileContent(withPropertyKey key: String) -> YWContent {
        let content = YWContent(propertyKey: key, langStruct: langStruct, superClass: superName, prefixStr: prefix)
        return content
    }
    
    func fileProperty(withPropertykey key: String, type: YWPropertyType) -> YWProperty {
        let property = YWProperty(propertyKey: key, type: type, langStruct: langStruct, prefixStr: prefix)
        return property
    }
    
    func toString() -> String {
        var totalStr = ""
        contents.forEach { (content) in
            totalStr += content.toString()
        }
        
        totalStr.removeFistChar()
        return totalStr
    }
    
    func toCacheConfig() -> Dictionary<String, Any> {
        return ["rootName": rootName, "prefix": prefix, "superName": superName, "langType": "\(langStruct.langType.rawValue)", "structType": "\(langStruct.structType.rawValue)"]
    }
    
    
    
    
}

