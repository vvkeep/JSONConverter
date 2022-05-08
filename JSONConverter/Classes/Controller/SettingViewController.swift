//
//  SettingViewController.swift
//  JSONConverter
//
//  Created by DevYao on 2020/8/28.
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
    
    @IBOutlet weak var customHeaderKeyLab: NSTextField!
    @IBOutlet weak var customHeaderSwitch: NSSwitch!
    
    @IBOutlet weak var headerKeyLab: NSTextField!
    @IBOutlet weak var headerField: NSTextField!
        
    @IBOutlet weak var autoHumpKeyLab: NSTextField!
    @IBOutlet weak var autoHumpSwitch: NSSwitch!
    
    @IBOutlet weak var saveBtn: NSButton!
    
    var fileConfigChangedClosure:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCacheConfigUI()
    }
    
    private func setupUI() {
        title = "parameter_setting_title".localized
        prefixKeyLab.stringValue = "parameter_classes_prefix".localized
        rootClassKeyLab.stringValue = "parameter_root_class_title".localized
        parentClassKeyLab.stringValue = "parameter_parent_class_title".localized
        customHeaderKeyLab.stringValue = "parameter_custom_file_header_title".localized
        autoHumpKeyLab.stringValue = "parameter_auto_case_underline_hump".localized
        headerKeyLab.stringValue = "parameter_file_header_title".localized
        saveBtn.title = "parameter_save_title".localized
        
        headerField.textColor = NSColor.hexInt(hex: 0x3ab54a)
        headerField.font = NSFont(name: "Menlo", size: 14)!
    }
    
    private func updateCacheConfigUI() {
        let configFile = FileCacheManager.shared.configFile()
        prefixField.stringValue = configFile.prefix ?? ""
        rootClassField.stringValue = configFile.rootName
        parentClassField.stringValue = configFile.parentName ?? ""
        autoHumpSwitch.state =  configFile.autoCaseUnderline ? .on : .off
        customHeaderSwitch.state = configFile.isCustomHeader ? .on : .off
        headerField.isEditable = customHeaderSwitch.state == .on
        headerField.stringValue = configFile.header ?? ""
    }
        
    @IBAction func saveConfigAction(_ sender: NSButton) {
        let configFile = FileCacheManager.shared.configFile()
        configFile.prefix = prefixField.stringValue
        configFile.rootName = rootClassField.stringValue
        configFile.parentName = parentClassField.stringValue
        configFile.header = headerField.stringValue
        configFile.isCustomHeader = customHeaderSwitch.state.rawValue == 1
        configFile.autoCaseUnderline = autoHumpSwitch.state.rawValue == 1
        FileCacheManager.shared.updateConfigWithFile(configFile)
        fileConfigChangedClosure?()
        dismiss(nil)
    }
    
    @IBAction func customFileHeaderSwitch(_ sender: NSSwitch) {
        let configFile = FileCacheManager.shared.configFile()
        configFile.isCustomHeader = customHeaderSwitch.state.rawValue == 1
        configFile.autoCaseUnderline = autoHumpSwitch.state.rawValue == 1
        FileCacheManager.shared.updateConfigWithFile(configFile)
        updateCacheConfigUI()
    }
}
