//
//  YWFile.swift
//  JSONExport
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 Ahmed Ali. All rights reserved.
//

import Foundation

class YWFile {
    
    var name: String = ""
    
    var prefix: String = ""
    
    var superName: String = ""
    
    var langStruct = LangStruct(langType: .Swift, structType: .struct)
    
    var header: String = ""
    
    var contents = [YWContent]()
    
    class func file(withName name: String, prefix: String, langStruct: LangStruct, superName: String) -> YWFile {
        let file = YWFile()
        file.name = name
        file.prefix = prefix
        file.langStruct = langStruct
        file.superName = superName
        return file
    }
    
    func toString() -> String {
        var totalStr = ""
        contents.forEach { (content) in
            totalStr += content.toString()
        }
        
        return totalStr
    }
}

