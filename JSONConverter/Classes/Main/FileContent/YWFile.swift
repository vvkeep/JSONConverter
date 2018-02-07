//
//  YWFile.swift
//  JSONExport
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 Ahmed Ali. All rights reserved.
//

import Foundation

class YWFile {
    
    /// 文件名
    var name: String = ""
    
    var prefix: String = ""
    
    var langStruct = LangStruct(langType: .Swift, structType: .struct)
    
    var header: String = ""
    
    var contents = [YWContent]()
    
    class func file(withName name: String, prefix: String, langStruct: LangStruct) -> YWFile {
        let file = YWFile()
        file.name = name
        file.prefix = prefix
        file.langStruct = langStruct
        return file
    }
    
    
    func toString() -> String {
        return ""
    }
}

