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
    
    var allSubClassStr = ""
    
    var prefixStr = ""
    
    var superClassStr: String = ""
    
    var transStructModelType: LangStruct = LangStruct(langType: .Swift, structType: .struct)
    
    
    ///------------------------------------------------------------------------------///
    
    private var file = YWFile()
    
    func handleEngine(frome obj: Any, langStruct: LangStruct, prefix: String, rootName: String, superName: String) -> String {
        file = YWFile.file(withName: rootName, prefix: prefix, langStruct: langStruct)
        let propertyKey = rootName.propertyName()
        
        switch obj {
        case let dic as [String: Any]:
            let content = handleDic(propertyKey: propertyKey, dic: dic)
            file.contents.append(content)
        case let arr as [Any]:
            _ = handleArr(itemKey: propertyKey, arr: arr)
            break
        default:
            assert(true, "对象类型不识别")
        }
        
        return file.toString()
    }
    
    private func handleDic(propertyKey: String, dic: [String: Any]) -> YWContent {
        let content = YWContent(langStruct: file.langStruct)
        
        dic.forEach { (item) in
            let itemKey = item.key
            var propertyModel: YWProperty?
            
            switch item.value {
            case _ as String:
                propertyModel = YWProperty(propertyKey: itemKey, type: .String, langStruct: file.langStruct)
            case let num as NSNumber:
                propertyModel = YWProperty(propertyKey: itemKey, type: num.valueType(), langStruct: file.langStruct)
            case let dic as [String: Any]:
                propertyModel = YWProperty(propertyKey: itemKey, type: .Dictionary, langStruct: file.langStruct)
                let content = handleDic(propertyKey: itemKey, dic: dic)
                file.contents.append(content)
            case let arr as [Any]:
                propertyModel = handleArr(itemKey: itemKey, arr: arr)
            default:
                assertionFailure("解析出现不识别类型")
                break
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
                propertyModel = YWProperty(propertyKey: itemKey, type: .ArrayString, langStruct: file.langStruct)
            case let num as NSNumber:
                let type = YWPropertyType(rawValue: num.valueType().hashValue + 6)!
                propertyModel = YWProperty(propertyKey: itemKey, type: type, langStruct: file.langStruct)
            case let dic as [String: Any]:
                propertyModel = YWProperty(propertyKey: itemKey, type: .ArrayDictionary, langStruct: file.langStruct)
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
    
    
    
    
    ///------------------------------------------------------------------------------///
    
    //    func handleObjEngine(from obj: Any, transModel: LangStruct, prefix: String, rootClassName: String, superClassName: String) -> String{
    //        allSubClassStr = ""
    //        prefixStr = prefix
    //        superClassStr = superClassName
    //        transStructModelType = transModel
    //
    //        let key = handlePropertyName(propertyKey: rootClassName)
    //
    //        switch obj {
    //        case let dic as Dictionary<String, Any>:
    //            _ = handleDictionary(from: dic, key: key, isArr: false)
    //        case let arr as Array<Any>:
    //            _ =  handleArray(from: arr, key: key)
    //        default:
    //            assert(true, "对象类型不识别")
    //        }
    //
    //        return allSubClassStr
    //    }
    //
    //    private func handleNumber(from num: NSNumber, key: String, isArr: Bool) -> (String, String){
    //        var numProStr = ""
    //        var swiftyJsonInitStr = ""
    //        if num.stringValue.contains(".") {
    //            numProStr = YWPropertyStrUtils.getCGFloatPropertyStr(transModel: transStructModelType, key: key, isArr: isArr)
    //            swiftyJsonInitStr = YWSwifyJSONInitUtils.getFloatInitStr(transModel: transStructModelType, key: key, isArr: isArr)
    //        }else{
    //            numProStr = YWPropertyStrUtils.getIntPropertyStr(transModel: transStructModelType, key: key, isArr: isArr)
    //            swiftyJsonInitStr = YWSwifyJSONInitUtils.getIntInitStr(transModel: transStructModelType, key: key, isArr: isArr)
    //        }
    //
    //        return (numProStr, swiftyJsonInitStr)
    //    }
    //
    //    private func handleString(from str: String, key: String, isArr: Bool) -> (String, String){
    //        let strProStr = YWPropertyStrUtils.getStringPropertyStr(transModel: transStructModelType, key: key, isArr: isArr)
    //        let swiftyJosnInitStr = YWSwifyJSONInitUtils.getStringInitStr(transModel: transStructModelType, key: key, isArr: isArr)
    //        return (strProStr, swiftyJosnInitStr)
    //    }
    //
    //    private func handleBool(from str: Bool, key: String, isArr: Bool) -> (String, String){
    //        let strProStr = YWPropertyStrUtils.getBoolPropertyStr(transModel: transStructModelType, key: key, isArr: isArr)
    //        let swiftyJosnInitStr = YWSwifyJSONInitUtils.getBoolInitStr(transModel: transStructModelType, key: key, isArr: isArr)
    //        return (strProStr, swiftyJosnInitStr)
    //    }
    //
    //    private func handleDictionary(from dic: [String: Any], key: String, isArr: Bool) -> (String, String){
    //        var propertyStr = ""
    //        var swiftyJsonInitStr = ""
    //
    //        dic.forEach { (tuple) in
    //            let key = handlePropertyName(propertyKey: tuple.key)
    //
    //            switch tuple.value {
    //            case let bool as Bool:
    //                let tupResult = handleBool(from: bool, key: key, isArr: false)
    //                propertyStr += tupResult.0
    //                swiftyJsonInitStr += tupResult.1
    //            case let num as NSNumber:
    //                let tupResult = handleNumber(from: num, key: key, isArr: false)
    //                propertyStr += tupResult.0
    //                swiftyJsonInitStr += tupResult.1
    //            case let str as String:
    //                let tupResult = handleString(from: str, key: key, isArr: false)
    //                propertyStr += tupResult.0
    //                swiftyJsonInitStr += tupResult.1
    //            case let dic as Dictionary<String, Any>:
    //                let tupResult = handleDictionary(from: dic, key: key, isArr: false)
    //                propertyStr += tupResult.0
    //                swiftyJsonInitStr += tupResult.1
    //            case let arr as Array<Any>:
    //                let tupResult = handleArray(from: arr, key: key)
    //                propertyStr += tupResult.0
    //                swiftyJsonInitStr += tupResult.1
    //            default:
    //                assert(true, "对象类型不识别")
    //            }
    //
    //        }
    //
    //        let subClassName = handleClassName(Key: key)
    //        let subClassStr = YWPropertyStrUtils.getClassStr(transModel: transStructModelType, className: subClassName, propertyStr: propertyStr, superClassName: superClassStr, swiftyJsonInitStr: swiftyJsonInitStr)
    //        allSubClassStr += subClassStr
    //
    //        propertyStr = YWPropertyStrUtils.getObjectPropertyStr(transModel: transStructModelType, key: key, className: subClassName, isArr: isArr)
    //
    //        swiftyJsonInitStr = YWSwifyJSONInitUtils.getObjInitStr(transModel: transStructModelType, key: key, className: subClassName, isArr: isArr)
    //
    //        return (propertyStr, swiftyJsonInitStr)
    //    }
    //
    //    private func handleArray(from arr: [Any], key: String) ->(String, String){
    //        if let obj = arr.first {
    //            switch obj {
    //            case let num as NSNumber:
    //                return handleNumber(from: num, key: key, isArr: true)
    //            case let str as String:
    //                return handleString(from: str, key: key, isArr: true)
    //            case let dic as Dictionary<String, Any>:
    //                return handleDictionary(from: dic, key: key, isArr: true)
    //            default:
    //                assert(true, "数组对象类型不识别")
    //                return ("", "")
    //            }
    //        }
    //         return ("", "")
    //    }
}

extension YWJsonParserUtils {
    private func handleClassName(Key: String) -> String {
        let Name =  Key as NSString
        if Name.length > 0 {
            let first = Name.substring(to: 1)
            let other = Name.substring(from: 1)
            return String(format: "%@%@%@", prefixStr, first.uppercased(), other)
        }
        
        return Name as String
    }
    
    private func handlePropertyName(propertyKey: String) -> String {
        let propertyName = propertyKey as NSString
        if  propertyName.length > 0 {
            let first = propertyName.substring(to: 1)
            let other = propertyName.substring(from: 1)
            return String(format: "%@%@", first.lowercased(), other)
        }
        
        return propertyName as String
    }
    
}


