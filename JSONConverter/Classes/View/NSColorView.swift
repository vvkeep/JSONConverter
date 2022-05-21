//
//  NSColorView.swift
//  JSONConverter
//
//  Created by yaow on 2022/5/21.
//  Copyright © 2022 Yao. All rights reserved.
//

import Foundation
import Cocoa

class NSColorView: NSView {
    var borderWidth: CGFloat = 1 { didSet { setNeedsDisplay(bounds) } }
    var borderColor: NSColor? { didSet { setNeedsDisplay(bounds) } }
    var backgroundColor: NSColor? { didSet { setNeedsDisplay(bounds) } }
    
    open override func draw(_ dirtyRect: NSRect) {
        if let backgroundColor = self.backgroundColor {
            backgroundColor.setFill()
            dirtyRect.fill()
        }
        
        if let borderColor = self.borderColor {
            borderColor.setStroke()
            let path = NSBezierPath(rect: dirtyRect)
            path.lineWidth = borderWidth
            path.stroke()
        }
    }
}
