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
    
    var isCustomHeader: Bool = false
    
    var prefix: String?
    
    var rootName: String = ""
    
    var parentName: String?
    
    var langStruct: LangStruct!
    
    var contents = [Content]()
    
    var theme = "tomorrow-night-bright"
    
    var autoCaseUnderline: Bool = false
    
    init(cacheConfig dic: [String: String]?) {
        self.rootName = dic?["rootName"] ?? "RootClass"
        self.prefix = dic?["prefix"] ?? ""
        self.parentName = dic?["parentName"] ?? ""
        
        let langIndex = Int(dic?["langType"] ?? "0")!
        let structIndex = Int(dic?["structType"] ?? "0")!
        let langType = LangType(rawValue: langIndex)!
        let structType = StructType(rawValue: structIndex)!
        let transStruct = LangStruct(langType: langType, structType: structType)
        self.langStruct = transStruct
        self.theme = dic?["theme"] ?? "tomorrow-night-bright"
        self.autoCaseUnderline = (dic?["autoCaseUnderline"] ?? "0").toBool()
        
        self.isCustomHeader = (dic?["isCustomHeader"] ?? "0").toBool()
        if self.isCustomHeader {
            self.header = dic?["header"] ?? ""
        }else {
            let suffix = classSuffixString().0
            self.header = defaultHeaderString(suffix: suffix)
        }
    }
    
    func contentWithKeyName(_ keyName: String) -> Content {
        let content = Content(propertyKey: keyName, langStruct: langStruct, parentClsName: parentName, prefixStr: prefix, autoCaseUnderline: autoCaseUnderline)
        return content
    }
    
    func propertyWithKeyName(_ keyName: String, type: PropertyType) -> Property {
        let property = Property(propertyKey: keyName, type: type, langStruct: langStruct, prefixStr: prefix, autoCaseUnderline: autoCaseUnderline)
        return property
    }
    
    func toString() -> (String, String?) {
        return (generateClassString(), generateClassImpString())
    }
    
    func toCacheConfig() -> [String: String] {
        return ["header": header, "isCustomHeader": "\(isCustomHeader ? 1 : 0)","rootName": rootName,
                "prefix": prefix ?? "","parentName": parentName ?? "", "autoCaseUnderline": "\(autoCaseUnderline ? 1 : 0)",
                "langType": "\(langStruct.langType.rawValue)",
                "structType": "\(langStruct.structType.rawValue)", "theme": theme]
    }
    
    func classSuffixString() -> (String, String?) {
        switch langStruct.langType {
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper, .Codable:
            return ( "swift", nil)
        case .ObjC:
            return ("h", "m")
        case .Flutter:
            return ("dart", nil)
        }
    }
}

extension File {
    
    private func defaultHeaderString(suffix: String) -> String {
        let headerString = """
        //
        //  \(rootName.className(withPrefix: prefix)).\(suffix)
        //
        //
        //  Created by JSONConverter on \(Date.now(format: "yyyy/MM/dd")).
        //  Copyright © \(Date.now(format: "yyyy"))年 JSONConverter. All rights reserved.
        //
        
        """
        return headerString
    }
    
    private func generateImportString() -> String? {
        switch langStruct.langType {
        case .Swift:
            return"\nimport Foundation\n"
        case .HandyJSON:
            return"\nimport Foundation\nimport HandyJSON\n"
        case .SwiftyJSON:
            return"\nimport Foundation\nimport SwiftyJSON\n"
        case .ObjectMapper:
            return"\nimport Foundation\nimport ObjectMapper\n"
        case .ObjC:
            var tempStr = "\n#import <Foundation/Foundation.h>\n"
            for (i, content) in contents.enumerated() where i > 0 {
                let propertyKey = autoCaseUnderline ? content.propertyKey.underlineToHump() : content.propertyKey
                tempStr += "\n@class \(propertyKey.className(withPrefix: content.prefixStr));"
            }
            tempStr += "\n"
            return tempStr
        case .Flutter:
            var className = rootName.className(withPrefix: prefix);
            let importStr = "\nimport 'package:json_annotation/json_annotation.dart';\n\npart '\(className.humpToUnderline()).g.dart';\n"
            return importStr
        case .Codable:
            return"\nimport Foundation\n"
        }
    }
    
    private func generateClassString() -> String {
        var classString = header ?? ""
        if let importString = generateImportString() {
            classString += importString
        }
        
        contents.forEach { (content) in
            classString += content.toString()
        }
        
        if StringUtils.isBlank(header) {
            classString.removeFistChar()
        }
        
        return classString
    }
    
    private func generateClassImpString() -> String? {
        switch langStruct.langType {
        case .ObjC:
            var tempString =  ""
            if isCustomHeader {
                tempString += header
            }else {
                tempString += defaultHeaderString(suffix: classSuffixString().1!)
            }
            
            if let content = contents.first {
                tempString += "\n#import \"\(content.propertyKey.className(withPrefix: prefix)).h\"\n"
            }
            
            for content in contents {
                let propertyKey = autoCaseUnderline ? content.propertyKey.underlineToHump() : content.propertyKey
                tempString += "\n@implementation \(propertyKey.className(withPrefix: content.prefixStr))\n\n@end\n"
            }
            
            return tempString
        default:
            return nil
        }
    }
}
