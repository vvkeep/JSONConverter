//
//  ClassHightTextStorage.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/9/7.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Cocoa

private let CLASSES_KEY_WORDS = ["import", "part", "class", "factory", "func", "this", "self", "struct", "var", "let", "required", "init", "func", "nonatomic", "copy", "strong", "assign"]
private let CLASSES_START_WAORD = ["@property", "@interface", "@end"]

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
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: str.count - range.length)
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


    }
    
}




