//
//  poemDetailViewController.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/25.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa

class PoemDetailViewController: NSViewController, NSTouchBarDelegate {
    
    let titleFontSize = 28
    let authorAndDynastyFontSize = 11
    
    init(title: String, dynasty: String, author: String, content: String) {
        poemTitle = title
        poemDynasty = dynasty
        poemAuthor = author
        poemContent = content
        poemParsedContent = manageParagraph(parsedString: content)
        super.init(nibName: NSNib.Name("PoemDetailViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet var contentField: NSTextView!
    
    @IBOutlet weak var autoNewLine: NSButton!
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var authorField: NSTextField!
    @IBOutlet weak var dynastyField: NSTextField!
    @IBOutlet weak var fontSizeSlider: NSSlider!
    @IBOutlet weak var fontSizeDisplay: NSTextField!
    
    @objc dynamic var isAutoLayout = false
    @objc dynamic var fontSize = 24
    
    var useSourceFont = true
    
    @IBAction func fontSizeChanger(_ sender: NSSlider) {
        self.fontSize = Int(fontSizeSlider.intValue)
        fontSizeDisplay.stringValue = "字号  \(self.fontSize) 磅"
    }
    
    @IBAction func onChecked(_ sender: NSButton) {
        if  autoNewLine.state == NSControl.StateValue.on {
            self.isAutoLayout = true
        } else {
            self.isAutoLayout = false
        }
        writeContent()
    }
    
    
    
    @objc dynamic var poemTitle = "静夜思"
    @objc dynamic var poemAuthor = "李白"
    @objc dynamic var poemDynasty = "唐朝"
    
    let userDefaults = UserDefaults.standard
    var poemContent = "床前明月光，疑是地上霜。举头望明月，低头思故乡。"
    var poemParsedContent = "床前明月光，疑是地上霜。\n举头望明月，低头思故乡。"
    
    
    override func viewDidLoad() {
        // Do view setup here.
        fontSize = userDefaults.integer(forKey: PreferenceKey.fontSizePoint)
        isAutoLayout = userDefaults.bool(forKey: PreferenceKey.autoLayout)
        useSourceFont = userDefaults.bool(forKey: PreferenceKey.useSourceSerif)
        super.viewDidLoad()
    }
    
    override func viewDidLayout() {
        contentField.isEditable = false
//        NSLog("Now, isAutoLayout = \(isAutoLayout), poemContent = \(poemContent), poemParsedContent = \(poemParsedContent)")
        titleField.stringValue = poemTitle
        authorField.stringValue = poemAuthor
        dynastyField.stringValue = poemDynasty
        if isAutoLayout {
            contentField.string = poemParsedContent
            autoNewLine.state = NSControl.StateValue.on
        } else {
            contentField.string = poemContent
            autoNewLine.state = NSControl.StateValue.off
        }
        fontSizeSlider.intValue = Int32(self.fontSize)
        fontSizeDisplay.stringValue = "字号  \(self.fontSize) 磅"
        if useSourceFont {
            contentField.font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(fontSize))
            titleField.font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(titleFontSize))
            authorField.font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(authorAndDynastyFontSize))
            dynastyField.font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(authorAndDynastyFontSize))
        }
        writeContent()
        super.viewDidLayout()
    }


    func writeContent() {
        if isAutoLayout {
            contentField.string = poemParsedContent
        } else {
            contentField.string = poemContent
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
            touchBarItem.view = NSButton(title: "🔺 更大", target: self, action: #selector(biggerFontSize(_:)))
            break
        case NSTouchBarItem.Identifier("Separator"):
            touchBarItem.view = NSScrubber()
            break
        case NSTouchBarItem.Identifier("smallerSize"):
            touchBarItem.view = NSButton(title: "🔻 更小", target: self, action: #selector(smallerFontize(_:)))
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


