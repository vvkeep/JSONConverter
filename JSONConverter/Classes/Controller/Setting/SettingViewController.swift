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
        
    @IBOutlet weak var saveBtn: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCacheConfig()
    }
    
    private func setupUI() {
        title = "parameter_setting_title".localized
        prefixKeyLab.stringValue = "parameter_classes_prefix".localized
        rootClassKeyLab.stringValue = "parameter_root_class_title".localized
        parentClassKeyLab.stringValue = "parameter_parent_class_title".localized
        headerKeyLab.stringValue = "parameter_file_header_title".localized
        saveBtn.title = "parameter_save_title".localized
    }
    
    private func setupCacheConfig() {
        let configFile = FileConfigManager.shared.defaultConfigFile()
        prefixField.stringValue = configFile.prefix ?? ""
        rootClassField.stringValue = configFile.rootName
        parentClassField.stringValue = configFile.parentName ?? ""
        headerField.stringValue = configFile.header ?? ""
    }
    
    @IBAction func saveConfigAction(_ sender: NSButton) {
        let configFile = FileConfigManager.shared.defaultConfigFile()
        configFile.prefix = prefixField.stringValue
        configFile.rootName = rootClassField.stringValue
        configFile.parentName = parentClassField.stringValue
        configFile.header = headerField.stringValue
        FileConfigManager.shared.updateConfigFile()
        dismiss(nil)
    }
}
