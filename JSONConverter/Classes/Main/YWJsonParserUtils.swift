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
            file.contents.insert(content, at: 0)
        }
        
        return file.toString()
    }
    
    private func handleDic(propertyKey: String, dic: [String: Any]) -> YWContent {
        let content = file.fileContent(withPropertyKey: propertyKey)
        
        dic.forEach { (item) in
            let itemKey = item.key
            var propertyModel: YWProperty?
            
            switch item.value {
            case _ as String:
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .String)
            case let num as NSNumber:
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: num.valueType())
            case let dic as [String: Any]:
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .Dictionary)
                let content = handleDic(propertyKey: itemKey, dic: dic)
                file.contents.insert(content, at: 0)
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
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .ArrayString)
            case let num as NSNumber:
                let type = YWPropertyType(rawValue: num.valueType().hashValue + 6)!
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: type)
            case let dic as [String: Any]:
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .ArrayDictionary)
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
    
    





