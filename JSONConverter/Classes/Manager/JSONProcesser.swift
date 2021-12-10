//
//  JSONParseManager.swift
//  Test
//
//  Created by Yao on 2018/2/3.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Foundation

class JSONProcesser {
    static let shared: JSONProcesser = {
        let manager = JSONProcesser()
        return manager
    }()
    
    private let builders: [PropertyBuildProtocol] = [ObjCPropertyBuilder(), SwiftPropertyBuilder(), SwiftyJSONPropertyBuilder(), ObjectMapperPropertyBuilder(), FlutterPropertyBuilder()]
    
    private var file: File!
    
    func builder(lang: LangType) -> PropertyBuildProtocol {
        return builders.first(where: { $0.isMatchLang(lang) })!
    }
    
    func buildWithJSONObject(_ obj: Any, file: File) -> (String, String?) {
        file.contents.removeAll()
        self.file = file
        var content: Content?
        let keyName = file.rootName.propertyName()
        
        switch obj {
        case let dic as [String: Any]:
            content = addDictionaryWithParentNodeName("", keyName: keyName, dic: dic)
        case let arr as [Any]:
            _ = addArrayWithParentNodeName("", keyName: keyName, valueArray: arr)
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
                property = addArrayWithParentNodeName(content.className, keyName: keyName, valueArray: arr)
            case  _ as NSNull:
                property = file.propertyWithParentNodeName(content.className, keyName: keyName, type: .Null)
            default:
                assertionFailure("build JSON object type error")
            }
            
            if let propertyModel = property {
                content.properties.append(propertyModel)
            }
        }
        
        return content
    }
    
    private func addArrayWithParentNodeName(_ parentNodeName: String, keyName: String, valueArray: [Any]) -> Property? {
        let item = valueArray.first is Dictionary<String, Any> ? buildPrefectDictionary(arrary: valueArray as! [[String: Any]]) : valueArray.first
        var propertyModel: Property?
        if let item = item {
            switch item {
            case _ as String:
                propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: .ArrayString)
            case let num as NSNumber:
                propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: num.valueType().arrayWrapperType())
            case let dic as [String: Any]:
                propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: .ArrayDictionary)
                let content = addDictionaryWithParentNodeName(parentNodeName, keyName: keyName, dic: dic)
                file.contents.insert(content, at: 0)
            case let arr as [Any]:
                propertyModel = addArrayWithParentNodeName(parentNodeName, keyName: keyName, valueArray: arr)
            default:
                assertionFailure("build JSON object type error")
            }
        } else {
            propertyModel = file.propertyWithParentNodeName(parentNodeName, keyName: keyName, type: .ArrayNull)
        }
        
        return propertyModel
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
