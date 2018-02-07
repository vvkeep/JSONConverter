//
//  YWContent.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/2/7.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
class YWContent {
    var properties = [YWProperty]()
    
    var langStruct: LangStruct
    
    init(langStruct: LangStruct) {
        self.langStruct = langStruct
    }
    
    func toString() -> String {
        return ""
    }
}
