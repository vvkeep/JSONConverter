//
//  FileDefaultConfigManager.swift
//  JSONConverter
//
//  Created by 姚巍 on 2020/8/29.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Foundation

struct FileConfigManager {
    
    var file = File(cachConfig: UserDefaults.standard.object(forKey: FILE_CACHE_CONFIG_KEY) as? [String: String?])
    
    static let `default`: FileConfigManager = {
       let manager = FileConfigManager()
        return manager
    }()
}
