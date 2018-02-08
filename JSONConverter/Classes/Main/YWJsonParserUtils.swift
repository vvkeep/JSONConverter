//
//  YWJsonParserUtils.swift
//  Test
//
//  Created by 姚巍 on 2018/2/3.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

typealias YWstructTypeContent = (propertyStr: String, SwiftyJSONInitStr: String)

class YWJsonParserUtils {
    
    static let shared: YWJsonParserUtils = {
        let manager = YWJsonParserUtils()
        return manager
    }()
    
    private var file = YWFile()
    
    func handleEngine(frome obj: Any, langStruct: LangStruct, prefix: String, rootName: String, superName: String) -> String {
        file = YWFile.file(withName: rootName, prefix: prefix, langStruct: langStruct, superName: superName)
        var content : YWContent?
        let propertyKey = rootName.propertyName()
        switch obj {
        case let dic as [String: Any]:
            content = handleDic(propertyKey: propertyKey, dic: dic)
        case let arr as [Any]:
            _ = handleArr(itemKey: propertyKey, arr: arr) 
        default:
            assert(true, "对象类型不识别")
        }
        
        if let content = content {
            file.contents.append(content)
        }
        
        return file.toString()
    }
    
    private func handleDic(propertyKey: String, dic: [String: Any]) -> YWContent {
        let content = YWContent(propertyKey: propertyKey, langStruct: file.langStruct, superClass: file.superName, prefixStr: file.prefix)
        
        dic.forEach { (item) in
            let itemKey = item.key
            var propertyModel: YWProperty?
            
            switch item.value {
            case _ as String:
                propertyModel = YWProperty(propertyKey: itemKey, type: .String, langStruct: file.langStruct, prefixStr: file.prefix)
            case let num as NSNumber:
                propertyModel = YWProperty(propertyKey: itemKey, type: num.valueType(), langStruct: file.langStruct, prefixStr: file.prefix)
            case let dic as [String: Any]:
                propertyModel = YWProperty(propertyKey: itemKey, type: .Dictionary, langStruct: file.langStruct, prefixStr: file.prefix)
                let content = handleDic(propertyKey: itemKey, dic: dic)
                file.contents.append(content)
            case let arr as [Any]:
                propertyModel = handleArr(itemKey: itemKey, arr: arr)
            case  _ as NSNull:
                break
            default:
                assertionFailure("解析出现不识别类型")
            }
            
            if let propertyModel = propertyModel {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func handleArr(itemKey: String, arr: [Any]) -> YWProperty? {
        if let first = arr.first {
            var propertyModel: YWProperty?
            switch first {
            case _ as String:
                propertyModel = YWProperty(propertyKey: itemKey, type: .ArrayString, langStruct: file.langStruct, prefixStr: file.prefix)
            case let num as NSNumber:
                let type = YWPropertyType(rawValue: num.valueType().hashValue + 6)!
                propertyModel = YWProperty(propertyKey: itemKey, type: type, langStruct: file.langStruct, prefixStr: file.prefix)
            case let dic as [String: Any]:
                propertyModel = YWProperty(propertyKey: itemKey, type: .ArrayDictionary, langStruct: file.langStruct, prefixStr: file.prefix)
                let content = handleDic(propertyKey: itemKey, dic: dic)
                file.contents.append(content)
            default:
                assertionFailure("解析出现不识别类型")
                break
            }
            
            return propertyModel
        }
        
        return nil
    }
    
}
    
    





