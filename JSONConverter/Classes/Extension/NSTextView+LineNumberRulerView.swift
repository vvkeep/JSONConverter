//
//  NSTextView+LineNumberRulerView.swift
//  macOS Application
//
//  Modified from https://github.com/yichizhang/NSTextView-LineNumberView
//  Created by Jiachen Ren on 2/25/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import AppKit
import Foundation
import ObjectiveC

var LineNumberViewAssocObjKey: UInt8 = 0

extension NSTextView {
    var lineNumberView: LineNumberRulerView {
        get {
            return objc_getAssociatedObject(self, &LineNumberViewAssocObjKey) as! LineNumberRulerView
        }
        set {
            objc_setAssociatedObject(
                self,
                &LineNumberViewAssocObjKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func setUpLineNumberView() {
        if let scrollView = enclosingScrollView {
            lineNumberView = LineNumberRulerView(textView: self)
            
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
            scrollView.verticalRulerView = lineNumberView
        }
        
        postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(lnv_frameDidChange),
            name: NSView.frameDidChangeNotification,
            object: self
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(lnv_textDidChange),
            name: NSText.didChangeNotification,
            object: self
        )
    }
    
    @objc func lnv_frameDidChange(notification: NSNotification) {
        lineNumberView.needsDisplay = true
    }
    
    @objc func lnv_textDidChange(notification: NSNotification) {
        lineNumberView.needsDisplay = true
    }
}

class LineNumberRulerView: NSRulerView {
    var font: NSFont! {
        return (self.clientView! as! NSTextView).font
    }
    
    var backgroundColor: NSColor {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var foregroundColor: NSColor = .gray {
        didSet {
            self.needsDisplay = true
        }
    }
    
    override var isFlipped: Bool {
        return false
    }
    
    init(textView: NSTextView) {
        self.backgroundColor = textView.backgroundColor
        
        super.init(
            scrollView: textView.enclosingScrollView!,
            orientation: NSRulerView.Orientation.verticalRuler
        )

        self.clientView = textView
        self.ruleThickness = 40
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawLineNumber(_ lineNumberString: String, at y: CGFloat) {
        guard let textView = clientView as? NSTextView else {
            return
        }
        
        let relativePoint = convert(NSPoint.zero, to: textView)
        let lineNumberAttributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: foregroundColor
        ]
        let attString = NSAttributedString(
            string: lineNumberString,
            attributes: lineNumberAttributes
        )
        let x = 35 - attString.size().width
        attString.draw(
            at: NSPoint(x: x, y: relativePoint.y - y)
        )
    }
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = clientView as? NSTextView,
            let layoutManager = textView.layoutManager else {
                return
        }
                
        // Draw background
        backgroundColor.setFill()
        rect.fill()
        
        let visibleGlyphRange = layoutManager.glyphRange(
            forBoundingRect: textView.visibleRect,
            in: textView.textContainer!
        )
        
        let firstVisibleGlyphCharacterIndex = layoutManager.characterIndexForGlyph(at: visibleGlyphRange.location)
        
        // The line number for the first visible line
        let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])
        var lineNumber = newLineRegex.numberOfMatches(
            in: textView.string,
            options: [],
            range: NSRange(location: 0, length: firstVisibleGlyphCharacterIndex)
        ) + 1
        
        var glyphIndexForStringLine = visibleGlyphRange.location
        
        // Go through each line in the string.
        while glyphIndexForStringLine < NSMaxRange(visibleGlyphRange) {
            // Range of current line in the string.
            let characterRangeForStringLine = (textView.string as NSString).lineRange(
                for: NSRange(location: layoutManager.characterIndexForGlyph(at: glyphIndexForStringLine), length: 0)
            )
            let glyphRangeForStringLine = layoutManager.glyphRange(
                forCharacterRange: characterRangeForStringLine,
                actualCharacterRange: nil
            )
            
            var glyphIndexForGlyphLine = glyphIndexForStringLine
            var glyphLineCount = 0
            
            while glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) {
                // See if the current line in the string spread across
                // several lines of glyphs
                var effectiveRange = NSRange(location: 0, length: 0)
                
                // Range of current "line of glyphs". If a line is wrapped,
                // then it will have more than one "line of glyphs"
                let lineRect = layoutManager.lineFragmentRect(
                    forGlyphAt: glyphIndexForGlyphLine,
                    effectiveRange: &effectiveRange,
                    withoutAdditionalLayout: true
                )
                
                let y = lineRect.maxY
                if glyphLineCount > 0 {
                    drawLineNumber(" ", at: y)
                } else {
                    drawLineNumber("\(lineNumber)", at: y)
                }
                
                // Move to next glyph line
                glyphLineCount += 1
                glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
            }
            
            glyphIndexForStringLine = NSMaxRange(glyphRangeForStringLine)
            lineNumber += 1
        }
        
        // Draw line number for the extra line at the end of the text
        if layoutManager.extraLineFragmentTextContainer != nil {
            drawLineNumber(
                "\(lineNumber)",
                at: layoutManager.extraLineFragmentRect.maxY
            )
        }
    }
}
