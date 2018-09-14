//
//  AuthorInfoViewController.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/29.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import Cocoa

class AuthorInfoViewController : NSViewController {
    @IBOutlet weak var authorNameTextField: NSTextField!
    @IBOutlet var infoTextField: NSTextView!
    
    
    init(author: String, content: String) {

        authorName = author
        authorInfo = content

        super.init(nibName: NSNib.Name("AuthorInfoViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let authorNameFontSize = 28
    let authorInfoFontSize = 24
    
    var authorName: String = ""
    var authorInfo: String = ""
    var countPrefix: String = ""
    var useSourceFont = true

    override func viewDidLoad() {

        let userDefaults = UserDefaults.standard
        useSourceFont = userDefaults.bool(forKey: PreferenceKey.useSourceSerif)
        if useSourceFont {
            authorNameTextField.font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(authorNameFontSize))
            infoTextField.font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(authorInfoFontSize))
        }
        super.viewDidLoad()
    }
    
    override func viewDidLayout() {
//        NSLog("Get fresh \(authorName), \(authorInfo)")
        let splitString = authorInfo.split(separator: "►")
        if splitString.count > 1 {
            self.infoTextField.string = String(splitString[0])
            countPrefix = "，收录\(splitString[1])。"
        } else {
            self.infoTextField.string = authorInfo
            countPrefix = ""
        }
        //        NSLog(String(splitString[1]))
        self.authorNameTextField.stringValue = authorName + countPrefix
        super.viewDidLayout()
    }
}
