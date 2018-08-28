//
//  AppUtils.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/25.
//  Copyright © 2018 yuxiqian. All rights reserved.
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

func regExReplace(in rawString: String, pattern: String, with: String,
                 options: NSRegularExpression.Options = []) -> String {
    let regex = try! NSRegularExpression(pattern: pattern, options: options)
    return regex.stringByReplacingMatches(in: rawString, options: [],
                                          range: NSMakeRange(0, rawString.count),
                                          withTemplate: with)
}

func manageParagraph(parsedString: String) -> String {
    return parsedString.regExReplace(pattern: "(\\[[^\\]]*?\\])", with: "").regExReplace(pattern: "(\\([^\\)]*?\\))", with: "").replacingOccurrences(of: "\n", with: "\n\n").replacingOccurrences(of: "。 ", with: "。").replacingOccurrences(of: "。", with: "。\n").replacingOccurrences(of: "?", with: "？").replacingOccurrences(of: "？ ", with: "？").replacingOccurrences(of: "？", with: "？\n").replacingOccurrences(of: "!", with: "！").replacingOccurrences(of: "！ ", with: "！").replacingOccurrences(of: "！", with: "！\n").replacingOccurrences(of: "；", with: "；\n")
}

extension String {
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }

    func regExReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
}
