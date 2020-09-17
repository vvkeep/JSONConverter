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
    
    // Choose Language
    @IBOutlet weak var converTypeBox: NSComboBox!
    
    // Choose Structure
    @IBOutlet weak var converStructBox: NSComboBox!
    
    @IBOutlet weak var JSONScrollViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var classScrollViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var horSpliteLineViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var verSplitLineView: PanGestureIndicatorView!
    @IBOutlet weak var horSplitLineView: PanGestureIndicatorView!
    
    @IBOutlet weak var classContainerView: NSView!
    
    @IBOutlet var JSONTextView: NSTextView!
    @IBOutlet var classTextView: NSTextView!
    @IBOutlet var classImpTextView: NSTextView!
    
    @IBOutlet weak var statusLab: NSTextField!
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
        
        classImpTextView.isEditable = false
        classImpTextView.setUpLineNumberView()
        
        JSONTextView.isAutomaticQuoteSubstitutionEnabled = false
        JSONTextView.isContinuousSpellCheckingEnabled = false
        JSONTextView.delegate = self
        JSONTextView.setUpLineNumberView()
        
        let jsonStorage = JSONHightTextStorage()
        jsonStorage.addLayoutManager(JSONTextView.layoutManager!)
        
        let classStorage = ClassHightTextStorage()
        classStorage.addLayoutManager(classTextView.layoutManager!)
        
        let classImpStorage = ClassHightTextStorage()
        classImpStorage.addLayoutManager(classImpTextView.layoutManager!)
        
        let verLineViewPan = NSPanGestureRecognizer(target: self, action: #selector(verLineViewPanSplitViewAction))
        verSplitLineView.addGestureRecognizer(verLineViewPan)
        verSplitLineView.causor = NSCursor.resizeLeftRight
        
        let horLineViewPan = NSPanGestureRecognizer(target: self, action: #selector(horLineViewPanSplitViewAction))
        horSplitLineView.addGestureRecognizer(horLineViewPan)
        horSplitLineView.causor = NSCursor.resizeUpDown
        
        updateJSONStatusLab(valid: false)
    }
    
    private func setupCacheConfig() {
        let configFile = FileConfigManager.shared.currentConfigFile()
        converTypeBox.selectItem(at: configFile.langStruct.langType.rawValue)
        converStructBox.selectItem(at: configFile.langStruct.structType.rawValue)
    }
    
    @IBAction func settingAction(_ sender: NSButton) {
        let settingVC = SettingViewController()
        settingVC.changeFileConfigClosure = { [weak self] in
            self?.generateClasses()
        }
        
        presentAsModalWindow(settingVC)
    }
    
    @IBAction func converBtnAction(_ sender: NSButton) {
        
    }
    
    func generateClasses() {
        if let data = JSONTextView.textStorage?.string.data(using: .utf8),
            let JSONObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject,
            let JSONData = try? JSONSerialization.data(withJSONObject: JSONObject, options: [.prettyPrinted, .sortedKeys]),
            let JSONString = String(data: JSONData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") {
            setupJSONTextViewContent(JSONString)
            
            let configFile = FileConfigManager.shared.currentConfigFile()
            let fileString = JSONParseManager.shared.handleEngine(frome: JSONObject, file:configFile)
            setupClassTextViewContent(fileString.0)
            setupClassImpTextViewContent(fileString.1)
            updateJSONStatusLab(valid: true)
        }else {
            updateJSONStatusLab(valid: false)
        }
    }
    
    private func updateJSONStatusLab(valid: Bool) {
        if valid {
            statusLab.stringValue = "app_converter_json_success_desc".localized
            statusLab.textColor = NSColor.systemGreen
        }else {
            statusLab.stringValue = "app_converter_json_error_desc".localized
            statusLab.textColor = NSColor.systemRed
        }
    }
    
    private func setupJSONTextViewContent(_ content: String){
        let attrContent = NSMutableAttributedString(string: content)
        JSONTextView.textStorage?.setAttributedString(attrContent)
    }
    
    private func setupClassTextViewContent(_ content: String) {
        let attrContent = NSMutableAttributedString(string: content)
        classTextView.textStorage?.setAttributedString(attrContent)
        classTextView.lineNumberView.needsDisplay = true
    }
    
    private func setupClassImpTextViewContent(_ content: String?) {
        if let content = content {
            let attrContent = NSMutableAttributedString(string: content)
            classImpTextView.textStorage?.setAttributedString(attrContent)
            classImpTextView.lineNumberView.needsDisplay = true
        }
    }
    
    private func updateUIAndConfigFile() {
        let configFile = FileConfigManager.shared.currentConfigFile()
        guard let langType = LangType(rawValue: converTypeBox.indexOfSelectedItem),
            let structType = StructType(rawValue: converStructBox.indexOfSelectedItem) else {
                assert(false, "lang or struct type error")
                return
        }
        
        if langType == .ObjC {
            horSpliteLineViewHeightCons.constant = 8
            classScrollViewHeightCons = classScrollViewHeightCons.setMultiplier(multiplier: 3.0/5)
            classImpTextView.isHidden = false
            horSplitLineView.isHidden = false
        }else {
            horSpliteLineViewHeightCons.constant = 0
            classScrollViewHeightCons = classScrollViewHeightCons.setMultiplier(multiplier: 1)
            classImpTextView.isHidden = true
            horSplitLineView.isHidden = true
        }
            
        let transStruct = LangStruct(langType: langType, structType: structType)
        configFile.langStruct = transStruct
        FileConfigManager.shared.updateConfigFile(file: configFile)
        
        generateClasses()
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
        
        updateUIAndConfigFile()
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
    
    func textDidChange(_ notification: Notification) {
        generateClasses()
    }
}

extension MainViewController {
    @objc private func verLineViewPanSplitViewAction(pan: NSPanGestureRecognizer) {
        let moveX = pan.location(in: self.view).x
        pan.setTranslation(CGPoint.zero, in: self.view)
        let raido = moveX / self.view.bounds.width
        if raido > 0.1 && raido < 0.9 {
            JSONScrollViewWidthCons = JSONScrollViewWidthCons.setMultiplier(multiplier: raido)
        }
    }
    
    @objc private func horLineViewPanSplitViewAction(pan: NSPanGestureRecognizer) {
        let moveY = pan.location(in: self.classContainerView).y
        pan.setTranslation(CGPoint.zero, in: self.classContainerView)
        let raido = (1 - moveY / self.classContainerView.bounds.height)
        if raido > 0.1 && raido < 0.9 {
            classScrollViewHeightCons = classScrollViewHeightCons.setMultiplier(multiplier: raido)
        }
    }
}

