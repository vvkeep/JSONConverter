//
//  FileContentModel.swift
//  JSONExport
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 Ahmed Ali. All rights reserved.
//

import Foundation

class FileContentModel {
    
    /// 文件名 == RootClssName
    var className: String
    
    var langStruct: LangStruct
    
    init(className: String, langStruct: LangStruct) {
        self.className = className
        self.langStruct = langStruct
    }
}

