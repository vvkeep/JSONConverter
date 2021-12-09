//
//  CustomBackgroundView.swift
//  JSONConverter
//
//  Created by DevYao on 2021/7/14.
//  Copyright © 2021 姚巍. All rights reserved.
//

import Cocoa

class CustomBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let color = NSColor(named: "LineColor")
        color?.setFill()
        bounds.fill()
    }
}
