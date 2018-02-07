//
//  String+Extension.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/1/28.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
extension String {
    func lowercaseFirstChar() -> String {
        if count > 0{
            let range = Range.init(startIndex..<index(startIndex, offsetBy: 1))
            let firstLowerChar = substring(with: range).lowercased()
            return replacingCharacters(in: range, with: firstLowerChar)
        }else {
            return self
        }
    }
}
