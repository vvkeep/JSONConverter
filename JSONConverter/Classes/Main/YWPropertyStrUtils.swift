//
//  YWCommonStrUtils.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/2/4.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation

class YWPropertyStrUtils {
    class func getCGFloatPropertyStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<CGFloat> *\(key);\n"
            }else{
                str = "@property (nonatomic, assign) CGFloat \(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "\tvar \(key) = [CGFloat]()\n"
            }else {
                str = "\tvar \(key): CGFloat = 0.0\n"
            }
        }
        
        return str
    }
    
    class func getIntPropertyStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<Int> *\(key);\n"
            }else{
                str = "@property (nonatomic, assign) Int \(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "\tvar \(key) = [Int]()\n"
            }else {
                str = "\tvar \(key): Int = 0\n"
            }
            
        }
        
        return str
    }
    
    
    class func getStringPropertyStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<NSString *> *\(key);\n"
            }else{
                str = "@property (nonatomic, copy) NSString *\(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "\tvar \(key) = [String]()\n"
            }else{
                str = "\tvar \(key): String?\n"
            }
            
        }
        
        return str
    }
    
    class func getBoolPropertyStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<BOOL> *\(key);\n"
            }else{
                str = "@property (nonatomic, assign) BOOL \(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "\tvar \(key) = [Bool]()\n"
            }else{
                str = "\tvar \(key): Bool = false\n"
            }
            
        }
        
        return str
    }
    
    class func getObjectPropertyStr(transModel: LangStruct, key: String, className: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .ObjC:
            if isArr {
                str = "@property (nonatomic, strong) NSArray<\(className) *> *\(key);\n"
            }else{
                str = "@property (nonatomic, strong) \(className) *\(key);\n"
            }
        case .Swift, .HandyJSON, .SwiftyJSON, .ObjectMapper:
            if isArr {
                str = "\tvar \(key) = [\(className)]()\n"
            }else{
                str = "\tvar \(key): \(className)?\n"
            }
            
        }
        
        return str
    }
    
    
    class func getClassStr(transModel: LangStruct, className: String, propertyStr: String, superClassName: String, swiftyJsonInitStr: String) -> String {
        var str = ""
        
        let superClassStr = getSuperClassStr(transModel: transModel, superClassStr: superClassName)
        
        if transModel.langType == .ObjC {
            str = "\n@interface \(className)\(superClassStr)\n\(propertyStr)\n@end\n"
        }else {
            switch transModel.structType {
            case .class:
                switch transModel.langType {
                case .Swift:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n}\n"
                case .HandyJSON:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n\trequired init() {}\n}\n"
                case .SwiftyJSON:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n\tinit(json: JSON) {\n\(swiftyJsonInitStr)\t}\n}\n"
                case .ObjectMapper:
                    str = "\nclass \(className)\(superClassStr) {\n\(propertyStr)\n\trequired init?(map: Map) {}\n\n\tfunc mapping(map: Map) {\n\(swiftyJsonInitStr)\t}\n}\n"
                default:
                    break
                }
            case .struct:
                switch transModel.langType {
                case .Swift, .HandyJSON:
                    str = "\nstruct \(className)\(superClassStr) {\n\(propertyStr)\n}\n"
                case .SwiftyJSON:
                    str = "\nstruct \(className)\(superClassStr) {\n\(propertyStr)\n\tinit(json: JSON) {\n\(swiftyJsonInitStr)\t}\n}\n"
                case .ObjectMapper:
                    str = "\nstruct \(className)\(superClassStr) {\n\(propertyStr)\n\tinit?(map: Map) {}\n\n\tmutating func mapping(map: Map) {\n\(swiftyJsonInitStr)\t}\n}\n"
                default:
                    break
                }
            }
        }
        
        return str
    }
    
    private class func getSuperClassStr(transModel: LangStruct, superClassStr: String) -> String {
        var superClassPart: String = ""
        
        switch transModel.langType {
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
    class func getFloatInitStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .SwiftyJSON:
            if isArr {
                str = "\t\t\(key) = json[\"\(key)\"].arrayValue.flatMap({$0.doubleValue})\n"
            }else {
                str = "\t\t\(key) = json[\"\(key)\"].floatValue\n"
            }
        case .ObjectMapper:
                str = "\t\t\(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    class func getStringInitStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .SwiftyJSON:
            if isArr {
                str = "\t\t\(key) = json[\"\(key)\"].arrayValue.flatMap({$0.stringValue})\n"
            }else {
                str = "\t\t\(key) = json[\"\(key)\"].stringValue\n"
            }
        case .ObjectMapper:
                str = "\t\t\(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    class func getIntInitStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .SwiftyJSON:
            if isArr {
                str = "\t\t\(key) = json[\"\(key)\"].arrayValue.flatMap({$0.intValue})\n"
            }else {
                str = "\t\t\(key) = json[\"\(key)\"].intValue\n"
            }
        case .ObjectMapper:
                str = "\t\t\(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    class func getBoolInitStr(transModel: LangStruct, key: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .SwiftyJSON:
            if isArr {
                str = "\t\t\(key) = json[\"\(key)\"].arrayValue.flatMap({$0.boolValue})\n"
            }else {
                str = "\t\t\(key) = json[\"\(key)\"].boolValue\n"
            }
        case .ObjectMapper:
                str = "\t\t\(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    
    class func getObjInitStr(transModel: LangStruct, key: String, className: String, isArr: Bool) -> String {
        var str = ""
        switch transModel.langType {
        case .SwiftyJSON:
            if isArr {
                str = "\t\t\(key) = json[\"\(key)\"].arrayValue.flatMap({\(className)(json: $0)})\n"
            }else {
                str = "\t\t\(key) = \(className)(json: json[\"\(key)\"])\n"
            }
        case .ObjectMapper:
                str = "\t\t\(key)        <- map[\"\(key)\"]\n"
        default:
            break
        }
        
        return str
    }
    
    
}

