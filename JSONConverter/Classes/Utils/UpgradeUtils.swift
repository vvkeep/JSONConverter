//
//  UpgradeUtils.swift
//  JSONConverter
//
//  Created by BOSMA on 2019/7/24.
//  Copyright © 2019 Yao. All rights reserved.
//

import Cocoa

class UpgradeUtils {
    
    static let GITHUB_RELEASES_URL = "https://api.github.com/repositories/120407973/releases"
    
    class func newestVersion(completion:@escaping ((VersionInfo?) -> ())) {
        DispatchQueue.global().async {
            guard let infoURL = URL(string: GITHUB_RELEASES_URL),
                let infoData = try? Data(contentsOf: infoURL),
                let list = try? JSONDecoder().decode([VersionInfo].self, from: infoData) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            
            DispatchQueue.main.async {
                completion(list.first)
            }
        }
    }
}
