//
//  VersionInfo.swift
//  JSONConverter
//
//  Created by BOSMA on 2019/7/24.
//  Copyright © 2019 姚巍. All rights reserved.
//

import Cocoa

class VersionInfo: Codable {
    var zipball_url: String?
    var assets_url: String?
    var html_url: String?
    var draft: Bool = false
    var tag_name: String?
    var published_at: String?
    var upload_url: String?
    var target_commitish: String?
    var body: String?
    var url: String?
    var prerelease: Bool = false
    var node_id: String?
    var name: String?
    var tarball_url: String?
    var created_at: String?
    var id: Int = 0

}
