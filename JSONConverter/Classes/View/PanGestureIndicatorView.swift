//
//  PanGestureSpliteLineView.swift
//  JSONConverter
//
//  Created by DevYao on 2020/9/16.
//  Copyright © 2020 DevYao. All rights reserved.
//

import Cocoa

class PanGestureIndicatorView: NSView {
    
    var causor: NSCursor = NSCursor.resizeLeftRight
    
    var dragging: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let area = NSTrackingArea(rect: self.bounds, options: [.enabledDuringMouseDrag, .mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow, .inVisibleRect], owner: self, userInfo: nil)
        addTrackingArea(area)
    }
        
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        causor.set()
        becomeFirstResponder()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseEntered(with: event)
        if dragging {
            causor.set()
        }else {
            NSCursor.arrow.set()
        }
    }
        
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        causor.set()
        becomeFirstResponder()
    }
    
    override func cursorUpdate(with event: NSEvent) {
        super.cursorUpdate(with: event)
        causor.set()
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        dragging = true
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        dragging = false
    }
}
