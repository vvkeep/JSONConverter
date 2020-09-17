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
        
    @IBOutlet weak var saveBtn: NSButton!
    
    var changeFileConfigClosure:(() -> ())?
    
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
        headerKeyLab.stringValue = "parameter_file_header_title".localized
        saveBtn.title = "parameter_save_title".localized
        
        headerField.textColor = NSColor.hexInt(hex: 0x3ab54a)
        headerField.font = NSFont(name: "Menlo", size: 14)!
    }
    
    private func updateCacheConfigUI() {
        let configFile = FileConfigManager.shared.currentConfigFile()
        prefixField.stringValue = configFile.prefix ?? ""
        rootClassField.stringValue = configFile.rootName
        parentClassField.stringValue = configFile.parentName ?? ""
        customHeaderSwitch.state = NSControl.StateValue(configFile.isCustomHeader)
        
        headerField.stringValue = configFile.header ?? ""
        
        if customHeaderSwitch.state == .on {
            headerField.isEditable = true
            headerField.layer?.borderWidth = 1
            headerField.layer?.borderColor = NSColor.hexInt(hex: 0x1AB6FF).cgColor
        }else {
            headerField.isEditable = false
            headerField.layer?.borderWidth = 0
            headerField.layer?.borderColor = nil
        }
    }
        
    @IBAction func saveConfigAction(_ sender: NSButton) {
        let configFile = FileConfigManager.shared.currentConfigFile()
        configFile.prefix = prefixField.stringValue
        configFile.rootName = rootClassField.stringValue
        configFile.parentName = parentClassField.stringValue
        configFile.header = headerField.stringValue
        configFile.isCustomHeader = customHeaderSwitch.state.rawValue
        FileConfigManager.shared.updateConfigFile(file: configFile)
        changeFileConfigClosure?()
        dismiss(nil)
    }
    
    @IBAction func customFileHeaderSwitch(_ sender: NSSwitch) {
        let configFile = FileConfigManager.shared.currentConfigFile()
        configFile.isCustomHeader = customHeaderSwitch.state.rawValue
        FileConfigManager.shared.updateConfigFile(file: configFile)
        updateCacheConfigUI()
    }
}
