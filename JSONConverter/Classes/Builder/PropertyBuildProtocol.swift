//
//  JSONBuilderProtocol.swift
//  JSONConverter
//
//  Created by 姚巍 on 2021/12/8.
//  Copyright © 2021 姚巍. All rights reserved.
//

import Cocoa

protocol PropertyBuildProtocol {
    func isMatchLang(_ lang: LangType) -> Bool
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String
    func initText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String
    func getterText(_ type: PropertyType) -> String
    func setterText(_ type: PropertyType) -> String
}

extension PropertyBuildProtocol {
    func initText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String {
        return ""
    }

    func getterText(_ type: PropertyType) -> String {
        return ""
    }
    
    func setterText(_ type: PropertyType) -> String {
        return ""
    }
}
