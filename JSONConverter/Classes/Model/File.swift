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
    
    private var builder: BuilderProtocol!
    
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
        self.builder = JSONProcesser.shared.builder(lang: langStruct.langType)
        
        self.isCustomHeader = (dic?["isCustomHeader"] ?? "0").toBool()
        if self.isCustomHeader {
            self.header = dic?["header"] ?? ""
        } else {
            let suffix = builder.fileSuffix()
            self.header = defaultHeaderString(suffix: suffix)
        }
    }
    
    func contentWithParentNodeName(_ parentNodeName: String, keyName: String) -> Content {
        let content = Content(parentNodeName: parentNodeName, keyName: keyName, langStruct: langStruct, parentClsName: parentName, prefixStr: prefix, autoCaseUnderline: autoCaseUnderline)
        return content
    }
    
    func propertyWithParentNodeName(_ parentNodeName: String, keyName: String, type: PropertyType) -> Property {
        let property = Property(parentNodeName: parentNodeName, keyName: keyName, type: type, langStruct: langStruct, prefixStr: prefix, autoCaseUnderline: autoCaseUnderline)
        return property
    }
    
    func toClassesString() -> String {
        let strategy: PropertyStrategy = autoCaseUnderline ? .underlineToHump : .origin
        let importStr = builder.fileImportText(rootName, contents: contents, strategy: strategy, prefix: prefix)
        var classString = (header ?? "") + importStr
        contents.forEach { (content) in
            classString += content.toContentClassString()
        }
        
        if StringUtils.isEmpty(header) {
            classString.removeFistChar()
        }
        
        return classString
    }
    
    func toClassesImplString() -> String? {
        let header = isCustomHeader ? header! : defaultHeaderString(suffix: builder.fileImplSuffix())
        let strategy: PropertyStrategy = autoCaseUnderline ? .underlineToHump : .origin
        let contentImplTexts = contents.map { builder.contentImplText($0, strategy: strategy) }
        let implStr = builder.fileImplText(header, rootName: rootName, prefix: prefix, contentCustomPropertyMapperTexts: contentImplTexts)
        return implStr
    }
    
    func toCacheConfig() -> [String: String] {
        return ["header": header, "isCustomHeader": "\(isCustomHeader ? 1 : 0)", "rootName": rootName,
                "prefix": prefix ?? "", "parentName": parentName ?? "", "autoCaseUnderline": "\(autoCaseUnderline ? 1 : 0)",
                "langType": "\(langStruct.langType.rawValue)",
                "structType": "\(langStruct.structType.rawValue)", "theme": theme]
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
}
