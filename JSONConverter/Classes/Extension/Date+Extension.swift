//
//  Date+Extension.swift
//  JSONConverter
//
//  Created by 姚巍 on 2020/8/29.
//  Copyright © 2020 姚巍. All rights reserved.
//

import Foundation

extension Date {
    
    static func now(format: String) -> String {
        let date = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = format
        let dateString = fmt.string(from: date)
        return dateString
    }
    
}
