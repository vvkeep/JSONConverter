//
//  FileDefaultConfigManager.swift
//  JSONConverter
//
//  Created by 姚巍 on 2020/8/29.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Foundation

class FileConfigManager {
    
    private var file = File(cacheConfig: UserDefaults.standard.object(forKey: FILE_CACHE_CONFIG_KEY) as? [String: String])
    
    static let shared: FileConfigManager = {
        let manager = FileConfigManager()
        return manager
    }()
    
    func defaultConfigFile() -> File {
        return file
    }
    
    func updateConfigFile() {
        let cacheDic = file.toCacheConfig()
        UserDefaults.standard.set(cacheDic, forKey: FILE_CACHE_CONFIG_KEY)
        UserDefaults.standard.synchronize()
    }
}
