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
    
    func buildWithJSONObject(_ obj: Any, file: File) -> (String, String?) {
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
            let keyName = item.key
            var property: Property?
            
            switch item.value {
            case _ as String:
                property = file.propertyWithKeyName(keyName, type: .String)
            case let num as NSNumber:
                property = file.propertyWithKeyName(keyName, type: num.valueType())
            case let dic as [String: Any]:
                property = file.propertyWithKeyName(keyName, type: .Dictionary)
                let content = addDictionaryWithKeyName(keyName, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                property = addArraryWithKeyName(keyName, valueArrary: arr)
            case  _ as NSNull:
                property = file.propertyWithKeyName(keyName, type: .nil)
            default:
                assertionFailure("build JSON object type error")
            }
            
            if let propertyModel = property {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func addArraryWithKeyName(_ keyName: String, valueArrary: [Any]) -> Property? {
        var item = valueArrary.first
        if valueArrary.first is Dictionary<String, Any> {
            var temp = [String: Any]()
            valueArrary.forEach { temp.merge($0 as! [String: Any]) { $1 } }
            item = temp
        }
        
        if let item = item {
            var propertyModel: Property?
            switch item {
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
                assertionFailure("build JSON object type error")
                break
            }
            
            return propertyModel
        }else {
            return nil
        }
    }
}
    
    





