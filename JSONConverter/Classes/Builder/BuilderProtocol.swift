//
//  BuilderProtocol.swift
//  JSONConverter
//
//  Created by Yao on 2021/12/8.
//  Copyright © 2021 Yao. All rights reserved.
//

import Cocoa

protocol BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String
    func initText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, typeName: String?) -> String
    func getterText(_ type: PropertyType) -> String
    func setterText(_ type: PropertyType) -> String
}

extension BuilderProtocol {
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
