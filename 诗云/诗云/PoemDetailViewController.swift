//
//  poemDetailViewController.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/25.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa

class PoemDetailViewController: NSViewController, NSTouchBarDelegate {

    @IBOutlet var contentField: NSTextView!
    @IBOutlet weak var autoNewLine: NSButton!
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var authorField: NSTextField!
    @IBOutlet weak var dynastyField: NSTextField!
    @IBOutlet weak var fontSizeSlider: NSSlider!
    @IBOutlet weak var fontSizeDisplay: NSTextField!
    
    var isAutoLayout = false
    
    
    @IBAction func fontSizeChanger(_ sender: NSSlider) {
        self.fontSize = Int(fontSizeSlider.intValue)
        fontSizeDisplay.stringValue = "字号  \(self.fontSize)"
    }
    
    @IBAction func onChecked(_ sender: NSButton) {
        writeContent()
    }
    
    @objc dynamic var poemTitle = "静夜思"
    @objc dynamic var poemAuthor = "李白"
    @objc dynamic var poemDynasty = "唐朝"
    @objc dynamic var poemContent = "床前明月光，疑是地上霜。举头望明月，低头思故乡。"
    @objc dynamic var poemParsedContent = "床前明月光，疑是地上霜。\n举头望明月，低头思故乡。"
    @objc dynamic var fontSize = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let userDefaults = UserDefaults.standard
        contentField.isEditable = false
        isAutoLayout = userDefaults.bool(forKey: PreferenceKey.autoLayout)
        if isAutoLayout {
            autoNewLine.state = NSControl.StateValue.on
        } else {
            autoNewLine.state = NSControl.StateValue.off
        }
        
        fontSize = userDefaults.integer(forKey: PreferenceKey.fontSizePoint)
        fontSizeSlider.intValue = Int32(self.fontSize)
        fontSizeDisplay.stringValue = "字号  \(self.fontSize)"
        writeContent()
    }


    func writeContent() {
        if (autoNewLine.state == NSControl.StateValue.on) {
            poemParsedContent = manageParagraph(parsedString: poemContent)
        } else {
            poemParsedContent = poemContent
        }
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [NSTouchBarItem.Identifier("textField"), NSTouchBarItem.Identifier("smallerSize"), NSTouchBarItem.Identifier("biggerSize"), NSTouchBarItem.Identifier("Separator"), NSTouchBarItem.Identifier("closePoem")]
        return touchBar
    }
    
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
        switch identifier {
        case NSTouchBarItem.Identifier("textField"):
            touchBarItem.view = NSTextField(labelWithString: "  文字  ")
            break
        case NSTouchBarItem.Identifier("biggerSize"):
            touchBarItem.view = NSButton(title: "🔺 变大", target: self, action: #selector(biggerFontSize(_:)))
            break
        case NSTouchBarItem.Identifier("Separator"):
            touchBarItem.view = NSTextField(labelWithString: "      ")
            break
        case NSTouchBarItem.Identifier("smallerSize"):
            touchBarItem.view = NSButton(title: "🔻 变小", target: self, action: #selector(smallerFontize(_:)))
            break
        case NSTouchBarItem.Identifier("closePoem"):
            touchBarItem.view = NSButton(title: "❌ 关闭", target: self, action: #selector(closePoem(_:)))
            break
        default:
            touchBarItem.view = NSButton(title: "defaultButton", target: self, action: nil)
            break
        }
        return touchBarItem
    }
    
    @objc func biggerFontSize(_ sender: NSButton) {
        if fontSize <= 60 {
            fontSizeSlider.intValue += 4
        } else {
            fontSizeSlider.intValue = 64
        }
        fontSizeChanger(fontSizeSlider)
    }
    
    @objc func smallerFontize(_ sender: NSButton) {
        if fontSize >= 20 {
            fontSizeSlider.intValue -= 4
        } else {
            fontSizeSlider.intValue = 16
        }
        fontSizeChanger(fontSizeSlider)
    }
    
    @objc func closePoem(_ sender: NSButton) {
        self.view.window!.close()
    }
}


