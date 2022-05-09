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
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String
    func propertyInitText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String
    func propertyGetterText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, keyTypeName: String?) -> String
    func propertySetterText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, keyTypeName: String?) -> String
    
    func contentParentClassText(_ clsText: String?) -> String
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: String, propertiesInitText: String?, propertiesGetterSetterText: String?) -> String

    func fileSuffix() -> String
    func fileImplSuffix() -> String
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export]
    
    func fileImplText(_ header: String, contents: [Content]) -> String
}

extension BuilderProtocol {
    func propertyInitText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        return ""
    }

    func propertyGetterText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, keyTypeName: String?) -> String {
        return ""
    }

    func propertySetterText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, keyTypeName: String?) -> String {
        return ""
    }
    
    func fileImplSuffix() -> String {
        return ""
    }
    
    func fileImplText(_ header: String, contents: [Content]) -> String {
        return ""
    }
}
