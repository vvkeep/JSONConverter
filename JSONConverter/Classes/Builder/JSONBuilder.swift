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
        let keyName = file.rootName.propertyName()
        
        switch obj {
        case let dic as [String: Any]:
            content = addDictionaryWithParentNodeName("", keyName: keyName, dic: dic)
        case let arr as [Any]:
            _ = addArraryWithParentNodeName("", keyName: keyName, valueArrary: arr)
        default:
            assertionFailure("parse object type error")
        }
        
        if let content = content {
            file.contents.insert(content, at: 0)
        }
        
        return file.toString()
    }
    
    private func addDictionaryWithParentNodeName(_ parentNodeName: String, keyName: String, dic: [String: Any]) -> Content {
        let content = file.contentWithParentNodeName(parentNodeName, keyName: keyName)
        
        dic.forEach { (item) in
            let keyName = item.key
            var property: Property?
            
            switch item.value {
            case _ as String:
                property = file.propertyWithParentNodeName(content.className, keyName: keyName, type: .String)
            case let num as NSNumber:
                property = file.propertyWithParentNodeName(content.className, keyName: keyName, type: num.valueType())
            case let dic as [String: Any]:
                property = file.propertyWithParentNodeName(content.className, keyName: keyName, type: .Dictionary)
                let content = addDictionaryWithParentNodeName(content.className, keyName: keyName, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                property = addArraryWithParentNodeName(content.className, keyName: keyName, valueArrary: arr)
            case  _ as NSNull:
                property = file.propertyWithParentNodeName(content.className, keyName: keyName, type: .nil)
            default:
                assertionFailure("build JSON object type error")
            }
            
            if let propertyModel = property {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func addArraryWithParentNodeName(_ parentNodeName: String, keyName: String, valueArrary: [Any]) -> Property? {
        let item = valueArrary.first is Dictionary<String, Any> ? buildPrefectDictionary(arrary: valueArrary as! [[String : Any]]) : valueArrary.first
        if let item = item {
            var propertyModel: Property?
            switch item {
            case _ as String:
                propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: .ArrayString)
            case let num as NSNumber:
                let type = PropertyType(rawValue: num.valueType().rawValue + 6)!
                propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: type)
            case let dic as [String: Any]:
                propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: .ArrayDictionary)
                let content = addDictionaryWithParentNodeName(parentNodeName, keyName: keyName, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                propertyModel = addArraryWithParentNodeName(parentNodeName, keyName: keyName, valueArrary: arr)
            default:
                assertionFailure("build JSON object type error")
                break
            }
            
            return propertyModel
        }else {
            return nil
        }
    }
    
    private func buildPrefectDictionary(arrary: [[String: Any]]) -> [String: Any] {
        var temp = [String: Any]()
        arrary.forEach {
            temp.merge($0) { (current, new) in
                if current is NSNull {
                    return new
                } else if ((current as? NSNumber)?.valueType()) == .Int {
                    if let newNumType = (new as? NSNumber)?.valueType() {
                        return (newNumType == .Float || newNumType == .Double) ? new : current
                    } else {
                        return new is NSNull ? current : new
                    }
                } else {
                    return current
                }
            }
        }
        
        return temp
    }
}







