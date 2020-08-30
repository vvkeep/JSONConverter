//
//  File.swift
//  JSONConverter
//
//  Created by Yao on 2018/2/7.
//  Copyright © 2018年 Ahmed Ali. All rights reserved.
//

import Foundation

class File {
    
    var header: String!
    
    var prefix: String?
    
    var parentName: String?
    
    var langStruct = LangStruct(langType: .Swift, structType: .struct)
        
    var contents = [Content]()
    
    var rootName: String = "RootClass"
    
    init(name: String, prefix: String?, header: String, langStruct: LangStruct, parentName: String?) {
        self.rootName = name
        self.prefix = prefix
        self.langStruct = langStruct
        self.parentName = parentName
        self.header = header
    }
    
    init(cacheConfig dic: [String: String]?) {
        self.rootName = dic?["rootName"] ?? "RootClass"
        self.prefix = dic?["prefix"] ?? ""
        self.parentName = dic?["parentName"] ?? ""
        self.header = StringUtils.isBlank(dic?["header"]) ? defaultHeaderString() : dic?["header"]

        let langIndex = Int(dic?["langType"] ?? "0")!
        let structIndex = Int(dic?["structType"] ?? "0")!
        let langType = LangType(rawValue: langIndex)!
        let structType = StructType(rawValue: structIndex)!
        let transStruct = LangStruct(langType: langType, structType: structType)
        self.langStruct = transStruct
    }
        
    func fileContent(withPropertyKey key: String) -> Content {
        let content = Content(propertyKey: key, langStruct: langStruct, parentClsName: parentName, prefixStr: prefix)
        return content
    }
    
    func fileProperty(withPropertykey key: String, type: PropertyType) -> Property {
        let property = Property(propertyKey: key, type: type, langStruct: langStruct, prefixStr: prefix)
        return property
    }
    
    func toString() -> String {
        var totalStr = header ?? ""
        if langStruct.langType == LangType.Flutter {
            var className = rootName.className(withPrefix: prefix);
            totalStr += "\nimport 'package:json_annotation/json_annotation.dart';\n\npart '\(className.underline()).g.dart';\n"
        }
        
        contents.sort { $0 < $1 }
        contents.forEach { (content) in
            totalStr += content.toString()
        }
        
        if StringUtils.isBlank(header) {
            totalStr.removeFistChar()
        }
        
        return totalStr
    }
    
    func toCacheConfig() -> [String: String?] {
        return ["header": header, "rootName": rootName, "prefix": prefix, "parentName": parentName, "langType": "\(langStruct.langType.rawValue)", "structType": "\(langStruct.structType.rawValue)"]
    }
    
    func defaultHeaderString() -> String {
        let headerString = """
        //
        //  \(rootName).\(langStruct.langType.suffix)
        //
        //
        //  Created by JSONConverter on \(Date.now(format: "yyyy/MM/dd")).
        //  Copyright © \(Date.now(format: "yyyy"))年 JSONConverter. All rights reserved.
        //
        """
        return headerString
    }
}
