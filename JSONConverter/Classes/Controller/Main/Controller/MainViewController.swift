//
//  MainViewController.swift
//  JSONConverter
//
//  Created by Yao on 2018/1/27.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    lazy var transTypeTitleList: [String] = {
        let titleArr = ["Swift", "HandyJSON", "SwiftyJSON", "ObjectMapper", "Objective-C", "Flutter", "Codable"]
        return titleArr
    }()
    
    lazy var structTypeTitleList: [String] = {
        let titleArr = ["Struct", "Class"]
        return titleArr
    }()
    
    // 选择 转换语言
    @IBOutlet weak var converTypeBox: NSComboBox!
    
    // 选择 类/结构体
    @IBOutlet weak var converStructBox: NSComboBox!
    
    @IBOutlet var jsonTextView: NSTextView!
    
    @IBOutlet var classTextView: NSTextView!
    
    @IBOutlet weak var convertBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCacheConfig()
        checkVerion()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminateNotiAction), name: NSNotification.Name.ApplicationWillTerminateNoti, object: nil)
    }
    
    private func checkVerion() {
        UpgradeUtils.newestVersion { (version) in
            guard let tagName = version?.tag_name,
                let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                let newVersion = Int(tagName.replacingOccurrences(of: ".", with: "")),
                let currentVeriosn = Int(bundleVersion.replacingOccurrences(of: ".", with: "")) else {
                    return
            }
            
            if newVersion > currentVeriosn {
                let upgradeVc = UpgradeViewController()
                upgradeVc.versionInfo = version
                upgradeVc.currentVer = bundleVersion
                self.presentAsModalWindow(upgradeVc)
            }
        }
    }
    
    private func setupUI() {
        convertBtn.title = "main_view_convert_btn_title".localized
        
        converTypeBox.addItems(withObjectValues: transTypeTitleList)
        converTypeBox.delegate = self
        
        converStructBox.addItems(withObjectValues: structTypeTitleList)
        converStructBox.delegate = self
        
        classTextView.isEditable = false
        classTextView.setUpLineNumberView()
        
        jsonTextView.isAutomaticQuoteSubstitutionEnabled = false
        jsonTextView.isContinuousSpellCheckingEnabled = false
        jsonTextView.delegate = self
        jsonTextView.setUpLineNumberView()
        
        let jsonStorage = JSONHightTextStorage()
        jsonStorage.addLayoutManager(jsonTextView.layoutManager!)
        
        let classStorage = ClassHightTextStorage()
        classStorage.addLayoutManager(classTextView.layoutManager!)
    }
    
    private func setupCacheConfig() {
        let configFile = FileConfigManager.shared.currentConfigFile()
        converTypeBox.selectItem(at: configFile.langStruct.langType.rawValue)
        converStructBox.selectItem(at: configFile.langStruct.structType.rawValue)
    }
    
    @IBAction func settingAction(_ sender: NSButton) {
        let settingVC = SettingViewController()
        presentAsModalWindow(settingVC)
    }
    
    @IBAction func converBtnAction(_ sender: NSButton) {
        if let jsonStr = jsonTextView.textStorage?.string {
            guard let jsonData = jsonStr.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)else{
                    alert(title: "app_converter_json_error_title".localized, desc: "app_converter_json_error_desc".localized)
                    return
            }
            
            if let formatJosnData = try? JSONSerialization.data(withJSONObject: json as AnyObject, options: .prettyPrinted),
                let formatJsonStr = String(data: formatJosnData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") {
                setupJSONTextViewContent(formatJsonStr)
            }
            
            let configFile = FileConfigManager.shared.currentConfigFile()
            let classStr = JSONParseManager.shared.handleEngine(frome: json, file:configFile)
            setupClassTextViewContent(classStr)
        }
    }
    
    private func setupJSONTextViewContent(_ content: String){
        let attrContent = NSMutableAttributedString(string: content)
        jsonTextView.textStorage?.setAttributedString(attrContent)
    }
    
    private func setupClassTextViewContent(_ content: String) {
        let attrContent = NSMutableAttributedString(string: content)
        classTextView.textStorage?.setAttributedString(attrContent)
    }
    
    private func updateConfigFile() {
        let configFile = FileConfigManager.shared.currentConfigFile()
        guard let langTypeType = LangType(rawValue: converTypeBox.indexOfSelectedItem),
            let structType = StructType(rawValue: converStructBox.indexOfSelectedItem) else {
                assert(false, "lang or struct type error")
                return
        }
        
        let transStruct = LangStruct(langType: langTypeType, structType: structType)
        configFile.langStruct = transStruct
        FileConfigManager.shared.updateConfigFile(file: configFile)
    }
    
    private func alert(title: String, desc: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = desc
        alert.runModal()
    }
}

extension MainViewController {
    @objc func applicationWillTerminateNotiAction() {
        let currentConfigFile = FileConfigManager.shared.currentConfigFile()
        FileConfigManager.shared.updateConfigFile(file: currentConfigFile)
    }
}

extension MainViewController: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let comBox = notification.object as! NSComboBox
        if comBox == converTypeBox { //Choose Language
            let langType = LangType(rawValue: converTypeBox.indexOfSelectedItem)
            if langType == LangType.ObjC || langType == LangType.Flutter { //if OC Flutter choose class
                converStructBox.selectItem(at: 1)
            } else if langType == LangType.Codable {//if Codable choose struct
                converStructBox.selectItem(at: 0)
            }
        }else if comBox == converStructBox { //Choose Structure
            let langType = LangType(rawValue: converTypeBox.indexOfSelectedItem)
            if langType == LangType.ObjC || langType == LangType.Flutter { // if OC Flutter choose class
                converStructBox.selectItem(at: 1)
            } else if langType == LangType.Codable { //if Codable choose struct
                converStructBox.selectItem(at: 0)
            }
        }
        
        updateConfigFile()
    }
}

extension MainViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if let value = link as? String,
            let url = URL(string: value) {
            NSWorkspace.shared.open(url)
        }
        return true
    }
}

