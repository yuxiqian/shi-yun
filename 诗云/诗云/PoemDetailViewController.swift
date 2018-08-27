//
//  poemDetailViewController.swift
//  诗云
//
//  Created by 法好 on 2018/8/25.
//  Copyright © 2018 法好. All rights reserved.
//

import Cocoa

class PoemDetailViewController: NSViewController {

    @IBOutlet var contentField: NSTextView!
    @IBOutlet weak var autoNewLine: NSButton!
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var authorField: NSTextField!
    @IBOutlet weak var dynastyField: NSTextField!
    var fontManager: NSFontManager = NSFontManager.shared
    @IBAction func onChecked(_ sender: NSButton) {
        writeContent()
    }
    
    @objc dynamic var poemTitle = "静夜思"
    @objc dynamic var poemAuthor = "李白"
    @objc dynamic var poemDynasty = "唐朝"
    @objc dynamic var poemContent = "床前明月光，疑是地上霜。举头望明月，低头思故乡。"
    @objc dynamic var poemParsedContent = "床前明月光，疑是地上霜。\n举头望明月，低头思故乡。"
    @objc dynamic var fontSize = 24

    @IBOutlet weak var fontSizeSlider: NSSlider!
    @IBAction func fontSizeChanger(_ sender: NSSlider) {
        self.fontSize = Int(fontSizeSlider.intValue)
        fontSizeDisplay.stringValue = "字号  \(self.fontSize)"
    }
    @IBOutlet weak var fontSizeDisplay: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        contentField.isEditable = false

        writeContent()
    }


    func writeContent() {
        if (autoNewLine.state == NSControl.StateValue.on) {
            poemParsedContent = manageParagraph(parsedString: poemContent)
        } else {
            poemParsedContent = poemContent
        }
    }
}


