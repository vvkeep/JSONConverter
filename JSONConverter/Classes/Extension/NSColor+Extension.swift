//
//  NSColor+Extension.swift
//  JSONConverter
//
//  Created by BOSMA on 2020/8/31.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Foundation
import AppKit

extension NSColor {
    class func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> NSColor {
        return NSColor(calibratedRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
        
    class func hexInt(hex : UInt32,alpha:CGFloat = 1.0) -> NSColor {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000ff) / 255.0
        return NSColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
