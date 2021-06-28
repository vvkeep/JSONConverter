//
//  JSONParseManager.swift
//  Test
//
//  Created by Yao on 2018/2/3.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation

class JSONBuilder {
    
    static let shared: JSONBuilder = {
        let manager = JSONBuilder()
        return manager
    }()
    
    private var file: File!
    
    func parseJSONObject(_ obj: Any, file: File) -> (String, String?) {
        file.contents.removeAll()
        self.file = file
        var content : Content?
        let propertyKey = file.rootName.propertyName()
        
        switch obj {
        case let dic as [String: Any]:
            content = addDictionaryWithKeyName(propertyKey, dic: dic)
        case let arr as [Any]:
            _ = addArraryWithKeyName(propertyKey, valueArrary: arr)
        default:
            assertionFailure("parse object type error")
        }
        
        if let content = content {
            file.contents.insert(content, at: 0)
        }
        
        return file.toString()
    }
    
    
    private func addDictionaryWithKeyName(_ keyName: String, dic: [String: Any]) -> Content {
        let content = file.contentWithKeyName(keyName)
        
        dic.forEach { (item) in
            let itemKey = item.key
            var propertyModel: Property?
            
            switch item.value {
            case _ as String:
                propertyModel = file.propertyWithKeyName(itemKey, type: .String)
            case let num as NSNumber:
                propertyModel = file.propertyWithKeyName(itemKey, type: num.valueType())
            case let dic as [String: Any]:
                propertyModel = file.propertyWithKeyName(itemKey, type: .Dictionary)
                let content = addDictionaryWithKeyName(itemKey, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                propertyModel = addArraryWithKeyName(itemKey, valueArrary: arr)
            case  _ as NSNull:
                propertyModel = file.propertyWithKeyName(itemKey, type: .nil)
            default:
                assertionFailure("parse object type error")
            }
            
            if let propertyModel = propertyModel {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func addArraryWithKeyName(_ keyName: String, valueArrary: [Any]) -> Property? {
        if valueArrary.count == 0 {
            return nil
        }
        
        if let first = valueArrary.first {
            var propertyModel: Property?
            switch first {
            case _ as String:
                propertyModel = file.propertyWithKeyName(keyName, type: .ArrayString)
            case let num as NSNumber:
                let type = PropertyType(rawValue: num.valueType().rawValue + 6)!
                propertyModel = file.propertyWithKeyName(keyName, type: type)
            case let dic as [String: Any]:
                propertyModel = file.propertyWithKeyName(keyName, type: .ArrayDictionary)
                let content = addDictionaryWithKeyName(keyName, dic: dic)
                file.contents.insert(content, at: 0)
            default:
                assertionFailure("parse object type error")
                break
            }
            
            return propertyModel
        }
        
        return nil
    }
}
    
    





