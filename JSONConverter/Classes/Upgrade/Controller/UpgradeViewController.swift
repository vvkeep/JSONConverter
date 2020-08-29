//
//  UpgradeViewController.swift
//  JSONConverter
//
//  Created by BOSMA on 2019/7/24.
//  Copyright © 2019 Yao. All rights reserved.
//

import Cocoa

class UpgradeViewController: NSViewController {
    
    @IBOutlet weak var verstionLab: NSTextField!
    @IBOutlet weak var currentVertionLab: NSTextField!
    @IBOutlet weak var descLab: NSTextField!
    
    var versionInfo: VersionInfo?
    var currentVer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "版本更新"
        verstionLab.stringValue = "最新版本: \(versionInfo?.tag_name ?? "未知")"
        currentVertionLab.stringValue = "目前版本: \(currentVer ?? "未知")"
        descLab.stringValue = "更新说明:\n" + (versionInfo?.body ?? "此版本无相关描述")
    }
    
    @IBAction func upgradeBtnAction(_ sender: NSButton) {
        if let htmlURL = versionInfo?.html_url,
            let url =  URL(string: htmlURL) {
            NSWorkspace.shared.open(url)
        }
    }
}
