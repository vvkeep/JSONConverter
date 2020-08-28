//
//  SettingViewController.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/8/28.
//  Copyright © 2020 Yao. All rights reserved.
//

import Cocoa

class SettingViewController: NSViewController {
    
    @IBOutlet weak var prefixKeyLab: NSTextField!
    @IBOutlet weak var prefixField: NSTextField!
    
    @IBOutlet weak var rootClassKeyLab: NSTextField!
    @IBOutlet weak var rootClassField: NSTextField!
    
    @IBOutlet weak var parentClassKeyLab: NSTextField!
    @IBOutlet weak var parentClassField: NSTextField!
    
    @IBOutlet weak var headerKeyLab: NSTextField!
    @IBOutlet weak var headerField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCacheConfig()
    }
    
    private func setupUI() {
        title = "parameter_setting_title".localized
    }
    
    private func setupCacheConfig() {
        if let config = UserDefaults.standard.object(forKey: FILE_CACHE_CONFIG_KEY) as? [String: String]  {
            let file = File.cacheFile(withDic: config)
            prefixField.stringValue = file.prefix
            rootClassField.stringValue = file.rootName
            parentClassField.stringValue = file.parentName
        }
    }
}
