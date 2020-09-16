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
    @IBOutlet weak var upgradeBtn: NSButton!
    
    var versionInfo: VersionInfo?
    var currentVer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "app_upgrade_veriosn_title".localized
        verstionLab.stringValue = "\( "app_latest_veriosn_title".localized): \(versionInfo?.tag_name ?? "app_common_unknown_title".localized)"
        currentVertionLab.stringValue = "\("app_current_veriosn_title".localized): \(currentVer ?? "app_common_unknown_title".localized)"
        descLab.stringValue = "\("app_upgrade_version_desc".localized):\n" + (versionInfo?.body ?? "app_common_unknown_title".localized)
        upgradeBtn.title = "app_upgrade_btn_title".localized
    }
    
    @IBAction func upgradeBtnAction(_ sender: NSButton) {
        if let htmlURL = versionInfo?.html_url,
            let url =  URL(string: htmlURL) {
            NSWorkspace.shared.open(url)
        }
    }
}
