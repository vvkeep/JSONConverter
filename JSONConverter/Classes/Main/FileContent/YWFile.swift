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
    var name: String
    
    var langStruct: LangStruct
    
    var header: String = ""
    
    var contents: [YWContent]
    
    init(className: String, langStruct: LangStruct, contents: [YWContent]) {
        self.name = className
        self.langStruct = langStruct
        self.contents = contents
    }
    
    func toString() -> String {
        return ""
    }
}

