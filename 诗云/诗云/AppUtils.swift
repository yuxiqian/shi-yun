//
//  AppUtils.swift
//  诗云
//
//  Created by 法好 on 2018/8/25.
//  Copyright © 2018 法好. All rights reserved.
//

import Foundation

func isIncludeChineseIn(string: String) -> Bool {
    for (_, value) in string.enumerated() {
        if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
            return true
        }
    }
    return false
}

func stringCompare(comparedStringOne s1: String, comparedStringTwo s2: String, isAscend: Bool) -> Bool {
    return (s1.localizedStandardCompare(s2).rawValue > 0) == isAscend
}

func manageParagraph(parsedString: String) -> String {
    return parsedString.replacingOccurrences(of: "。 ", with: "。").replacingOccurrences(of: "。", with: "。\n").replacingOccurrences(of: "?", with: "？").replacingOccurrences(of: "？ ", with: "？").replacingOccurrences(of: "？", with: "？\n").replacingOccurrences(of: "!", with: "！").replacingOccurrences(of: "！ ", with: "！").replacingOccurrences(of: "！", with: "！\n")
}
