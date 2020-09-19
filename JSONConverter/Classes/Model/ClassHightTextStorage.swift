//
//  ClassHightTextStorage.swift
//  JSONConverter
//
//  Created by DevYao on 2020/9/7.
//  Copyright © 2020 DevYao. All rights reserved.
//

import Cocoa


private let CLASSES_KEY_WORDS = ["import", "part", "class", "factory", "func", "this", "self", "struct", "var", "let", "required", "init", "func", "nonatomic", "copy", "strong", "assign", "mutating", "extends"]
private let CLASSES_START_WAORD = ["@property", "@interface", "@end", "@class", "#import", "@implementation"]
private let CLASSSES_PROPERTY_TYPES = ["NSString", "NSInteger", "NSInteger", "BOOL", "String", "Int", "Bool", "NSArray", "int", "List", "bool"]

class ClassHightTextStorage: NSTextStorage {
    
    var _string = NSMutableAttributedString()
        
    override var string: String {
        return _string.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return _string .attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        _string.replaceCharacters(in: range, with: str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        _string.setAttributes(attrs, range: range)
        edited(.editedCharacters, range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        performReplacementsForRange(changedRange: editedRange)
        super.processEditing()
    }
}

extension ClassHightTextStorage {
    
    func performReplacementsForRange(changedRange: NSRange) {
         addAttributes([.font: NSFont(name: "Menlo", size: 14)!, .foregroundColor: NSColor.labelColor], range: changedRange)
        
        let paragaphRange = NSString(string: string).paragraphRange(for: editedRange)
        
        // comment hightlight
        let commentPatterns = try! NSRegularExpression(pattern: "(?<!http:|https:|\\S)//.*", options: .caseInsensitive)
        commentPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x3ab54a)], range: result!.range)
        }

        // keywords highlight
        CLASSES_KEY_WORDS.forEach { (keyword) in
            let nullPatterns = try! NSRegularExpression(pattern: "\\b\(keyword)\\b", options: .caseInsensitive)
            nullPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
                self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0xDA1878)], range: result!.range)
            }
        }
        
        // start keywors highlight
        CLASSES_START_WAORD.forEach { (keyword) in
            let nullPatterns = try! NSRegularExpression(pattern: "(?<=\\s)\(keyword)", options: .caseInsensitive)
            nullPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
                self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0xDA1878)], range: result!.range)
            }
        }
        
        // double quota string highlight
        let doubleStringPatterns = try! NSRegularExpression(pattern: "\".*?\"", options: .caseInsensitive)
        doubleStringPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0xBC2B36)], range: result!.range)
        }
        
        // single quota string highlight
        let singleStringPatterns = try! NSRegularExpression(pattern: "'.*?'", options: .caseInsensitive)
        singleStringPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0xBC2B36)], range: result!.range)
        }
        
        // value type highlight
        CLASSSES_PROPERTY_TYPES.forEach { (keyword) in
            let nullPatterns = try! NSRegularExpression(pattern: "\\b\(keyword)\\b", options: .caseInsensitive)
            nullPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
                self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x3F9BBA)], range: result!.range)
            }
        }
        
        // class name hliglight
        let classNamePatterns = try! NSRegularExpression(pattern: "(?<=class\\s|struct\\s|@interface\\s)[a-zA-z]+(?=:|\\s|\\s\\{)", options: .caseInsensitive)
        classNamePatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x5CD7FF)], range: result!.range)
        }
                
        // parent class name hliglight
        let parentNamePatterns = try! NSRegularExpression(pattern: "(?<=:\\s|extends\\s)[a-zA-z]+(?=\\n|\\s\\{)", options: .caseInsensitive)
        parentNamePatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x8FDA58)], range: result!.range)
        }
    }
}






