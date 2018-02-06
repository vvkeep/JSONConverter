//
//  YWCommonStrUtils.swift
//  YWJsonModelConverter
//
//  Created by 姚巍 on 2018/2/4.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

class YWPropertyStrUtils {
    class func getCGFloatPropertyStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<CGFloat> *\(key);\n"
            }else{
                str = "@property (nonatomic, assign) CGFloat \(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "      var \(key) = [CGFloat]()\n"
            }else {
                str = "      var \(key): CGFloat = 0.0\n"
            }
        }
        
        return str
    }
    
    class func getIntPropertyStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<Int> *\(key);\n"
            }else{
                str = "@property (nonatomic, assign) Int \(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "      var \(key) = [Int]()\n"
            }else {
                str = "      var \(key): Int = 0\n"
            }
            
        }
        
        return str
    }
    
    
    class func getStringPropertyStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<NSString *> *\(key);\n"
            }else{
                str = "@property (nonatomic, copy) NSString *\(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "      var \(key) = [String]()\n"
            }else{
                str = "      var \(key): String?\n"
            }
            
        }
        
        return str
    }
    
    class func getBoolPropertyStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<BOOL> *\(key);\n"
            }else{
                str = "@property (nonatomic, assign) BOOL \(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "      var \(key) = [Bool]()\n"
            }else{
                str = "      var \(key): Bool = false\n"
            }
            
        }
        
        return str
    }
    
    class func getObjectPropertyStr(transModel: YWTransStructModel, key: String, className: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<\(className) *> *\(key);\n"
            }else{
                str = "@property (nonatomic, strong) \(className) *\(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "      var \(key) = [\(className)]()\n"
            }else{
                str = "      var \(key): \(className)?\n"
            }
            
        }
        
        return str
    }
    
    
    class func getClassStr(transModel: YWTransStructModel, className: String, propertyStr: String, superClassName: String, swiftyJsonInitStr: String) -> String {
        var str = ""
        
        let superClassStr = getSuperClassStr(transModel: transModel, superClassStr: superClassName)
        
        if transModel.transform == .ObjC {
            str = "\n@interface \(className)\(superClassStr)\n\(propertyStr)\n@end\n"
        }else {
            switch transModel.structure {
            case .class:
                switch transModel.transform {
                case .Swift:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n}\n"
                case .HandyJSON:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n       required init() {}\n}\n"
                case .SwiftyJSON:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n       init(json: JSON) {\n\(swiftyJsonInitStr)       }\n}\n"
                case .ObjectMapper:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n       required init?(map: Map) {\n       }\n       func mapping(map: Map) {\n\(swiftyJsonInitStr)}\n}\n"
                default:
                    break
                }
            case .struct:
                switch transModel.transform {
                case .Swift, .HandyJSON:
                    str = "\nstruct \(className)\(superClassStr) {\n\(propertyStr)\n}\n"
                case .SwiftyJSON:
                    str = "\nstruct \(className)\(superClassStr) {\n\(propertyStr)\n       init(json: JSON) {\n\(swiftyJsonInitStr)       }\n}\n"
                case .ObjectMapper:
                    str = "\nstruct \(className)\(superClassStr) {\n\(propertyStr)\n       init?(map: Map) {\n       }\n       mutating func mapping(map: Map) {\n\(swiftyJsonInitStr)}\n}\n"
                default:
                    break
                    
                }
            }
        }
        
        return str
    }
    
    private class func getSuperClassStr(transModel: YWTransStructModel, superClassStr: String) -> String {
        var superClassPart: String = ""
        
        switch transModel.transform {
        case .HandyJSON:
            superClassPart = superClassStr.isEmpty ? ": HandyJSON" : ": \(superClassStr)"
        case .Swift, .SwiftyJSON:
            superClassPart = superClassStr.isEmpty ? "" : ": \(superClassStr)"
        case .ObjC:
            superClassPart = superClassStr.isEmpty ? ": NSObject" : ": \(superClassStr)"
        case .ObjectMapper:
            superClassPart = superClassStr.isEmpty ? ": Mappable" : ": \(superClassStr)"
            break
        }
        
        return superClassPart
    }
}


class YWSwifyJSONInitUtils {
    class func getFloatInitStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .SwiftyJSON:
            if isArr {
                str = "            \(key) = json[\"\(key)\"].arrayValue.flatMap({$0.doubleValue})\n"
            }else {
                str = "            \(key) = json[\"\(key)\"].floatValue\n"
            }
        case .ObjectMapper:
                str = "            \(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    class func getStringInitStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .SwiftyJSON:
            if isArr {
                str = "            \(key) = json[\"\(key)\"].arrayValue.flatMap({$0.stringValue})\n"
            }else {
                str = "            \(key) = json[\"\(key)\"].stringValue\n"
            }
        case .ObjectMapper:
                str = "            \(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    class func getIntInitStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .SwiftyJSON:
            if isArr {
                str = "            \(key) = json[\"\(key)\"].arrayValue.flatMap({$0.intValue})\n"
            }else {
                str = "            \(key) = json[\"\(key)\"].intValue\n"
            }
        case .ObjectMapper:
                str = "            \(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    class func getBoolInitStr(transModel: YWTransStructModel, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .SwiftyJSON:
            if isArr {
                str = "            \(key) = json[\"\(key)\"].arrayValue.flatMap({$0.boolValue})\n"
            }else {
                str = "            \(key) = json[\"\(key)\"].boolValue\n"
            }
        case .ObjectMapper:
                str = "            \(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    
    class func getObjInitStr(transModel: YWTransStructModel, key: String, className: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.transform {
        case .SwiftyJSON:
            if isArr {
                str = "            \(key) = json[\"\(key)\"].arrayValue.flatMap({\(className)(json: $0)})\n"
            }else {
                str = "            \(key) = \(className)(json: json[\"\(key)\"])\n"
            }
        case .ObjectMapper:
                str = "            \(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    
}

