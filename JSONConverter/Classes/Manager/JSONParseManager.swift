//
//  JSONParseManager.swift
//  Test
//
//  Created by Yao on 2018/2/3.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation

class JSONParseManager {
    
    static let shared: JSONParseManager = {
        let manager = JSONParseManager()
        return manager
    }()
    
    private var file: File!
    
    func handleEngine(frome obj: Any, file: File) -> String {
        self.file = file
        self.file.contents.removeAll()
        var content : Content?
        let propertyKey = file.rootName.propertyName()
        switch obj {
        case let dic as [String: Any]:
            content = handleDic(propertyKey: propertyKey, dic: dic)
        case let arr as [Any]:
            _ = handleArr(itemKey: propertyKey, arr: arr) 
        default:
            assertionFailure("parse object type error")
        }
        
        if let content = content {
            file.contents.insert(content, at: 0)
        }
        
        return file.toString()
    }
    
    private func handleDic(propertyKey: String, dic: [String: Any]) -> Content {
        let content = file.fileContent(withPropertyKey: propertyKey)
        
        dic.forEach { (item) in
            let itemKey = item.key
            var propertyModel: Property?
            
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
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .nil)
            default:
                assertionFailure("parse object type error")
            }
            
            if let propertyModel = propertyModel {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func handleArr(itemKey: String, arr: [Any]) -> Property? {
        if let first = arr.first {
            var propertyModel: Property?
            switch first {
            case _ as String:
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .ArrayString)
            case let num as NSNumber:
                let type = PropertyType(rawValue: num.valueType().rawValue + 6)!
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: type)
            case let dic as [String: Any]:
                propertyModel = file.fileProperty(withPropertykey: itemKey, type: .ArrayDictionary)
                let content = handleDic(propertyKey: itemKey, dic: dic)
                file.contents.append(content)
            default:
                assertionFailure("parse object type error")
                break
            }
            
            return propertyModel
        }
        
        return nil
    }
}
    
    





