//
//  PanGestureSpliteLineView.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/9/16.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Cocoa

class PanGestureIndicatorView: NSView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let area = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(area)
    }
        
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSCursor.resizeLeftRight.set()
        
        becomeFirstResponder()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSCursor.arrow.set()
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        NSCursor.resizeLeftRight.set()
        becomeFirstResponder()

    }
    
    override func cursorUpdate(with event: NSEvent) {
        NSCursor.resizeLeftRight.set()
    }
}
