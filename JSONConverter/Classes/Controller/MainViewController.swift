//
//  MainViewController.swift
//  JSONConverter
//
//  Created by Yao on 2018/1/27.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Cocoa
import Highlightr

class MainViewController: NSViewController {
    @IBOutlet weak var languagesPopup: NSPopUpButton!
    @IBOutlet weak var structurePopup: NSPopUpButton!
    @IBOutlet weak var themePopup: NSPopUpButton!
    
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
    @IBOutlet weak var saveBtn: NSButton!
    
    private let highlightr = Highlightr()!
    
    private lazy var JSONStorage: CodeAttributedString = {
        let storage = CodeAttributedString()
        storage.highlightr.setTheme(to: "tomorrow-night-bright")
        storage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        storage.language = "json"
        return storage
    }()
    
    private lazy var classStorage: CodeAttributedString = {
        let storage = CodeAttributedString()
        storage.highlightr.setTheme(to: "tomorrow-night-bright")
        storage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        return storage
    }()
    
    private lazy var classImpStorage: CodeAttributedString = {
        let storage = CodeAttributedString()
        storage.highlightr.setTheme(to: "tomorrow-night-bright")
        storage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        return storage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCacheConfig()
        checkVersion()
        updateConfigUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminateNotificationAction),
                                               name: NSNotification.Name.ApplicationWillTerminateNotification, object: nil)
    }
    
    private func checkVersion() {
        UpgradeUtils.newestVersion { (version) in
            guard let tagName = version?.tag_name,
                  let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return
            }
            
            if tagName.compare(bundleVersion) == .orderedDescending {
                let upgradeVc = UpgradeViewController()
                upgradeVc.versionInfo = version
                upgradeVc.currentVer = bundleVersion
                self.presentAsModalWindow(upgradeVc)
            }
        }
    }
    
    private func setupUI() {
        saveBtn.title = "parameter_save_title".localized
        
        languagesPopup.removeAllItems()
        languagesPopup.addItems(withTitles: LangType.allValues().map({ $0.title }))
        
        structurePopup.removeAllItems()
        structurePopup.addItems(withTitles: StructType.strusts())
        
        themePopup.removeAllItems()
        themePopup.addItems(withTitles: highlightr.availableThemes())
        
        classTextView.isEditable = false
        classTextView.setUpLineNumberView()
        
        classImpTextView.isEditable = false
        classImpTextView.setUpLineNumberView()
        
        JSONTextView.isAutomaticQuoteSubstitutionEnabled = false
        JSONTextView.isContinuousSpellCheckingEnabled = false
        JSONTextView.delegate = self
        JSONTextView.setUpLineNumberView()
        
        //        let languages = highlightr.supportedLanguages()
        //        let themes = highlightr.availableThemes()
        //        print("languages: \(languages)\n themes:\(themes)")
        
        JSONStorage.addLayoutManager(JSONTextView.layoutManager!)
        classStorage.addLayoutManager(classTextView.layoutManager!)
        classImpStorage.addLayoutManager(classImpTextView.layoutManager!)
        
        classImpTextView.textColor = NSColor.labelColor
        classTextView.textColor = NSColor.labelColor
        
        let verLineViewPan = NSPanGestureRecognizer(target: self, action: #selector(verLineViewPanSplitViewAction))
        verSplitLineView.addGestureRecognizer(verLineViewPan)
        verSplitLineView.causor = NSCursor.resizeLeftRight
        
        let horLineViewPan = NSPanGestureRecognizer(target: self, action: #selector(horLineViewPanSplitViewAction))
        horSplitLineView.addGestureRecognizer(horLineViewPan)
        horSplitLineView.causor = NSCursor.resizeUpDown
        
        showJSONOperateResult(false, content: nil)
    }
    
    private func loadCacheConfig() {
        let config = FileCacheManager.shared.configFile()
        languagesPopup.selectItem(at: config.langStruct.langType.rawValue)
        structurePopup.selectItem(at: config.langStruct.structType.rawValue)
        if let themeIndex = highlightr.availableThemes().firstIndex(where: { config.theme == $0 }) {
            themePopup.selectItem(at: themeIndex)
            let theme = highlightr.availableThemes()[themeIndex]
            upateTextThemeUI(theme)
        }
    }
    
    @IBAction func settingAction(_ sender: NSButton) {
        let settingVC = SettingViewController()
        settingVC.fileConfigChangedClosure = { [weak self] in
            self?.generateClasses()
        }
        
        presentAsModalWindow(settingVC)
    }
    
    @IBAction func saveBtnAction(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsOtherFileTypes = false
        openPanel.treatsFilePackagesAsDirectories = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.prompt = "main_view_export_choose_title".localized
        openPanel.beginSheetModal(for: self.view.window!) { button in
            if button == NSApplication.ModalResponse.OK {
                self.exportClassesFileWithPath(openPanel.url!.path)
                self.showSaveSuccessAction()
            }
        }
    }
    
    func exportClassesFileWithPath(_ path: String) {
        let config = FileCacheManager.shared.configFile()
        let builder = JSONProcesser.shared.builder(lang: config.langStruct.langType)
        let content = classTextView.textStorage?.string ?? ""
        let implContent = classImpTextView.textStorage?.string ?? ""
        let exports = builder.fileExport(path, config: config, content: content, classImplContent: implContent)
        
        for export in exports {
            do {
                try export.content.write(toFile: export.path, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                alertError(error)
            }
        }
    }
    
    func showSaveSuccessAction() {
        let notification = NSUserNotification()
        notification.title = "main_view_export_save_success_title".localized
        notification.informativeText = "main_view_export_save_success_desc".localized
        notification.deliveryDate = Date()
        
        let center = NSUserNotificationCenter.default
        center.delegate = self
        center.deliver(notification)
    }
    
    func generateClasses() {
        guard let JSONTextViewString = JSONTextView.textStorage?
            .string.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined(separator: ""),
              JSONTextViewString.count > 0 else {
            setupClassTextViewContent("")
            setupClassImpTextViewContent("")
            return
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        DispatchQueue.global().async {
            if let JSONTextViewData = JSONTextViewString.data(using: .utf8),
               let JSONObject = try? JSONSerialization.jsonObject(with: JSONTextViewData, options: [.mutableContainers, .mutableLeaves]),
               let JSONData = try? JSONSerialization.data(withJSONObject: JSONObject, options: [.sortedKeys, .prettyPrinted]),
               let JSONString = String(data: JSONData, encoding: .utf8) {
                let file = FileCacheManager.shared.configFile()
                let fileString = JSONProcesser.shared.buildWithJSONObject(JSONObject, file: file)
                let endTime1 = CFAbsoluteTimeGetCurrent()
                let offsetTime1 = Int((endTime1 - startTime) * 1000)
                
                DispatchQueue.main.async {
                    self.setupJSONTextViewContent(JSONString)
                    self.setupClassTextViewContent(fileString.0)
                    self.setupClassImpTextViewContent(fileString.1)
                    self.showJSONOperateResult(true, content: JSONTextViewString)
                    let endTime2 = CFAbsoluteTimeGetCurrent()
                    let offsetTime2 = Int((endTime2 - endTime1) * 1000)
                    print("convert duration: \(offsetTime1)ms, display duration: \(offsetTime2)ms")
                }
            } else {
                DispatchQueue.main.sync {
                    self.showJSONOperateResult(false, content: JSONTextViewString)
                }
            }
        }
    }
    
    private func showJSONOperateResult(_ result: Bool, content: String?) {
        statusLab.stringValue = result ? "app_converter_json_success_desc".localized : "app_converter_json_error_desc".localized
        statusLab.textColor = result ? NSColor.systemGreen : NSColor.systemRed
        saveBtn.isEnabled = result
        print("JSON Convert:\(result ? "true" : "fasle"), JSONString: \(content ?? "")")
    }
    
    private func setupJSONTextViewContent(_ content: String) {
        let attrContent = NSAttributedString(string: content)
        JSONTextView.textStorage?.setAttributedString(attrContent)
    }
    
    private func setupClassTextViewContent(_ content: String) {
        let attrContent = NSAttributedString(string: content)
        classTextView.textStorage?.setAttributedString(attrContent)
        classTextView.lineNumberView.needsDisplay = true
    }
    
    private func setupClassImpTextViewContent(_ content: String?) {
        if let content = content {
            let attrContent = NSAttributedString(string: content)
            classImpTextView.textStorage?.setAttributedString(attrContent)
            classImpTextView.lineNumberView.needsDisplay = true
        }
    }
    
    private func upateTextThemeUI(_ theme: String) {
        classStorage.highlightr.setTheme(to: theme)
        classImpStorage.highlightr.setTheme(to: theme)
        JSONStorage.highlightr.setTheme(to: theme)
        
        classStorage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        classImpStorage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
        JSONStorage.highlightr.theme.codeFont = NSFont(name: "Menlo", size: 14)
    }
    
    private func updateConfigUI() {
        let config = FileCacheManager.shared.configFile()
        guard let langType = LangType(rawValue: languagesPopup.indexOfSelectedItem),
              let structType = StructType(rawValue: structurePopup.indexOfSelectedItem)
        else {
            assert(false, "lang or struct type error")
            return
        }
        
        classImpStorage.language = langType.language
        classStorage.language = langType.language
        
        if langType.isDoubleClassFiles {
            horSpliteLineViewHeightCons.constant = 8
            classScrollViewHeightCons = classScrollViewHeightCons.setMultiplier(multiplier: 3.0/5)
            classImpTextView.isHidden = false
            horSplitLineView.isHidden = false
        } else {
            horSpliteLineViewHeightCons.constant = 0
            classScrollViewHeightCons = classScrollViewHeightCons.setMultiplier(multiplier: 1)
            classImpTextView.isHidden = true
            horSplitLineView.isHidden = true
        }
        
        let transStruct = LangStruct(langType: langType, structType: structType)
        config.langStruct = transStruct
        
        let theme = highlightr.availableThemes()[themePopup.indexOfSelectedItem]
        config.theme = theme
        FileCacheManager.shared.updateConfigWithFile(config)
        generateClasses()
    }
    
    private func alert(title: String, desc: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = desc
        alert.runModal()
    }
    
    func alertError(_ error: NSError) {
        let alert = NSAlert(error: error)
        alert.runModal()
    }
}

extension MainViewController {
    @objc func applicationWillTerminateNotificationAction() {
        let config = FileCacheManager.shared.configFile()
        FileCacheManager.shared.updateConfigWithFile(config)
    }
}

extension MainViewController {
    @IBAction func languageSelectedChanged(_ sender: NSPopUpButton) {
        let langType = LangType(rawValue: sender.indexOfSelectedItem)!
        if langType.onlyCompatibleClass {
            structurePopup.selectItem(at: 1)
        } else if langType.onlyCompatibleStruct {
            structurePopup.selectItem(at: 0)
        }
        
        updateConfigUI()
    }
    
    @IBAction func structureSelectedChanged(_ sender: NSPopUpButton) {
        let langType = LangType(rawValue: languagesPopup.indexOfSelectedItem)!
        if langType.onlyCompatibleClass {
            structurePopup.selectItem(at: 1)
        } else if langType.onlyCompatibleStruct {
            structurePopup.selectItem(at: 0)
        }
        
        updateConfigUI()
    }

    @IBAction func themeSelctedChanged(_ sender: NSPopUpButton) {
        let theme = highlightr.availableThemes()[sender.indexOfSelectedItem]
        upateTextThemeUI(theme)
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

extension MainViewController: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
