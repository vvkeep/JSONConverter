//
//  JSONHightTextStorage.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/8/31.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Cocoa

private let JSON_KEY_WORDS = ["null", "false", "true"]

class JSONHightTextStorage: NSTextStorage {
    
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

extension JSONHightTextStorage {
    func performReplacementsForRange(changedRange: NSRange) {
         addAttributes([.font: NSFont(name: "Menlo", size: 14)!, .foregroundColor: NSColor.labelColor], range: changedRange)
        
        let paragaphRange = NSString(string: string).paragraphRange(for: editedRange)
        
        // string hightlight
        let valuePatterns = try! NSRegularExpression(pattern: "\".*?\"", options: .caseInsensitive)
        valuePatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x3ab54a)], range: result!.range)
        }
        
        // key hightlight
        let keyPatterns = try! NSRegularExpression(pattern: "\".*?\" :", options: .caseInsensitive)
        keyPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            let range = result!.range
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x92278f)], range: NSRange(location: range.location, length: range.length - 1))
        }

        // value number hightlight
        let numPatterns = try! NSRegularExpression(pattern: "(?<=: )\\d+.*", options: .caseInsensitive)
        numPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x25aae2)], range: result!.range)
        }
        
        // value URL highlight
        let urlPatterns = try! NSRegularExpression(pattern: "\"[a-zA-z]+://[^\\s]*\"", options: .caseInsensitive)
        urlPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
            self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0x61D2D6)],
                               range: result!.range)
            let underlineRnage = NSRange(location: result!.range.location + 1, length: result!.range.length - 2)
            self.addAttributes([.underlineStyle : NSNumber(value: NSUnderlineStyle.single.rawValue)], range: underlineRnage)
            let linkString = string.subString(rang: underlineRnage)
            self.addAttributes([.link : linkString], range: underlineRnage)
        }
        
        // keywords highlight
        JSON_KEY_WORDS.forEach { (keyword) in
            let nullPatterns = try! NSRegularExpression(pattern: "(?<=: )\(keyword)", options: .caseInsensitive)
            nullPatterns.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragaphRange) { (result, flags, _) in
                self.addAttributes([.foregroundColor: NSColor.hexInt(hex: 0xf1592a)], range: result!.range)
            }
        }
    }
}



