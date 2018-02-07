//
//  MainViewController.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/1/27.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Cocoa

enum LangType: Int {
    case Swift = 0
    case HandyJSON
    case SwiftyJSON
    case ObjectMapper
    case ObjC
}

enum StructType: Int {
    case `struct` = 0
    case `class`
}

struct LangStruct {
    var langType: LangType
    var structType: StructType
    
    init(langType: LangType, structType: StructType) {
        self.langType = langType
        self.structType = structType
    }
}

class MainViewController: NSViewController {
    
    lazy var transTypeTitleArr: [String] = {
        let titleArr = ["Swift", "HandyJSON", "SwiftyJSON", "ObjectMapper", "Objective-C"]
        return titleArr
    }()
    
    lazy var structTypeTitleArr: [String] = {
        let titleArr = ["struct", "class"]
        return titleArr
    }()
    
    /// 转换模式Box
    @IBOutlet weak var converTypeBox: NSComboBox!
    
    @IBOutlet weak var converStructBox: NSComboBox!
    
    @IBOutlet weak var prefixField: NSTextField!
    
    @IBOutlet weak var rootClassField: NSTextField!
    
    @IBOutlet weak var superClassField: NSTextField!
    
    @IBOutlet var jsonTextView: NSTextView!
    
    @IBOutlet var classTextView: NSTextView!
    
    private var _isConver: Bool = false
    
    private var prefixName = "YW"
    
    private var rootClassName = "RootClass"
        
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupUI()
    }
    
    private func setupUI(){
        converTypeBox.addItems(withObjectValues: transTypeTitleArr)
        converTypeBox.selectItem(at: 0)
        converTypeBox.delegate = self
        
        converStructBox.addItems(withObjectValues: structTypeTitleArr)
        converStructBox.selectItem(at: 0)
        
        classTextView.isEditable = false
        jsonTextView.isAutomaticQuoteSubstitutionEnabled = false
    }
    
    @IBAction func supportMeAction(_ sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "http://devyao.com/about/")!)
    }
    
    @IBAction func converBtnAction(_ sender: NSButton) {
        _isConver = true
        var rootClassName = rootClassField.stringValue
        if rootClassName.count == 0 {
            rootClassName = "RootClass"
        }
        
        if let jsonStr = jsonTextView.textStorage?.string {
            guard let jsonData = jsonStr.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)else{
                    let alert = NSAlert()
                    alert.messageText = "转换出错"
                    alert.informativeText = "未知数据格式无法解析,请提供正确的Json字符串"
                    alert.runModal()
                    return
            }
            
            if let formatJosnData = try? JSONSerialization.data(withJSONObject: json as AnyObject, options: .prettyPrinted),
                let formatJsonStr = String(data: formatJosnData, encoding: .utf8){
                setJsonContent(content: formatJsonStr)
            }
            
            if rootClassField.stringValue.count > 0{
                rootClassName = rootClassField.stringValue
            }
            
            if prefixField.stringValue.count > 0 {
                prefixName = prefixField.stringValue
            }
            
            guard let langTypeType = LangType(rawValue: converTypeBox.indexOfSelectedItem),
                let structType = StructType(rawValue: converStructBox.indexOfSelectedItem) else {
                    return
            }
            
            let transStructModel = LangStruct(langType: langTypeType, structType: structType)
            let classString = YWJsonParserUtils.shared.handleObjEngine(from: json, transModel: transStructModel,  prefix: prefixName, rootClassName: rootClassName, superClassName: superClassField.stringValue)
            
            setClassContent(content: classString)
        }
    }
    
    
    private func setJsonContent(content: String){
        if content.count > 0{
            let attrContent = NSMutableAttributedString(string: content)
            jsonTextView.textStorage?.setAttributedString(attrContent)
            jsonTextView.textStorage?.font = NSFont.systemFont(ofSize: 14)
            jsonTextView.textStorage?.foregroundColor = NSColor.darkGray
        }
    }
    
    private func setClassContent(content: String) {
        if content.count > 0{
            let attrContent = NSMutableAttributedString(string: content)
            classTextView.textStorage?.setAttributedString(attrContent)
            classTextView.textStorage?.font = NSFont.systemFont(ofSize: 14)
            classTextView.textStorage?.foregroundColor = NSColor.black
        }
    }
}

extension MainViewController: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let comBox = notification.object as! NSComboBox
        let langType = LangType(rawValue: comBox.indexOfSelectedItem)
        
        if langType == LangType.ObjC {
            converStructBox.selectItem(at: 1)
        }
        
    }
}

