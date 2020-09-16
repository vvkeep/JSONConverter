//
//  PanGestureSpliteLineView.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/9/16.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Cocoa

class PanGestureSpliteLineView: NSView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let area = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(area)
    }
        
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        print("---- mouseEntered -----")
        NSCursor.resizeLeftRight.set()
        becomeFirstResponder()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseEntered(with: event)
        print("********** mouseExited **********")
        NSCursor.arrow.set()
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        print("########### mouseMoved ###########")
        NSCursor.resizeLeftRight.set()
        becomeFirstResponder()

    }
    
    override func mouseDragged(with event: NSEvent) {
        print("哈哈哈哈哈哈哈哈哈")

    }
    override func cursorUpdate(with event: NSEvent) {
        print("呵呵呵呵呵呵")
        NSCursor.resizeLeftRight.set()

    }
}
