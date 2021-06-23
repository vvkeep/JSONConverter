//
//  FileDefaultConfigManager.swift
//  JSONConverter
//
//  Created by DevYao on 2020/8/29.
//  Copyright © 2020 DevYao. All rights reserved.
//

import Foundation

private let FILE_CACHE_CONFIG_KEY = "FILE_CACHE_CONFIG_KEY"

class FileConfigManager {
    
    private lazy var fileConfigDic: [String: String]? = {
        let dic = UserDefaults.standard.object(forKey: FILE_CACHE_CONFIG_KEY) as? [String: String]
        return dic
    }()
        
    static let shared: FileConfigManager = {
        let manager = FileConfigManager()
        return manager
    }()
    
    func currentConfigFile() -> File {
        let file = File(cacheConfig: fileConfigDic)
        return file
    }
    
    func updateConfigWithFile(_ file: File) {
        fileConfigDic = file.toCacheConfig()
        UserDefaults.standard.set(fileConfigDic, forKey: FILE_CACHE_CONFIG_KEY)
        UserDefaults.standard.synchronize()
    }
}
