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
            content = addDictionaryWithPreviousNodeName("", keyName: propertyKey, dic: dic)
        case let arr as [Any]:
            _ = addArraryWithPreviousNodeName("", keyName: propertyKey, valueArrary: arr)
        default:
            assertionFailure("parse object type error")
        }
        
        if let content = content {
            file.contents.insert(content, at: 0)
        }
        
        return file.toString()
    }
    
    
    private func addDictionaryWithPreviousNodeName(_ rootClassName: String, keyName: String, dic: [String: Any]) -> Content {
        let content = file.contentWithPreviousNodeName(rootClassName, keyName: keyName)
        
        dic.forEach { (item) in
            let keyName = item.key
            var property: Property?
            
            switch item.value {
            case _ as String:
                property = file.propertyWithPreviousNodeName(content.className, keyName: keyName, type: .String)
            case let num as NSNumber:
                property = file.propertyWithPreviousNodeName(content.className, keyName: keyName, type: num.valueType())
            case let dic as [String: Any]:
                property = file.propertyWithPreviousNodeName(content.className, keyName: keyName, type: .Dictionary)
                let content = addDictionaryWithPreviousNodeName(content.className, keyName: keyName, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                property = addArraryWithPreviousNodeName(content.className, keyName: keyName, valueArrary: arr)
            case  _ as NSNull:
                property = file.propertyWithPreviousNodeName(content.className, keyName: keyName, type: .nil)
            default:
                assertionFailure("build JSON object type error")
            }
            
            if let propertyModel = property {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func addArraryWithPreviousNodeName(_ previousNodeName: String, keyName: String, valueArrary: [Any]) -> Property? {
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
                propertyModel = file.propertyWithPreviousNodeName(previousNodeName, keyName: keyName, type: .ArrayString)
            case let num as NSNumber:
                let type = PropertyType(rawValue: num.valueType().rawValue + 6)!
                propertyModel = file.propertyWithPreviousNodeName(previousNodeName, keyName: keyName, type: type)
            case let dic as [String: Any]:
                propertyModel = file.propertyWithPreviousNodeName(previousNodeName, keyName: keyName, type: .ArrayDictionary)
                let content = addDictionaryWithPreviousNodeName(previousNodeName, keyName: keyName, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                propertyModel = addArraryWithPreviousNodeName(previousNodeName, keyName: keyName, valueArrary: arr)
                break
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
    
    





