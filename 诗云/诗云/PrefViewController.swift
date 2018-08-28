//
//  PrefViewController.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/27.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import Cocoa

class PrefViewController: NSViewController {
    @IBOutlet weak var autoLoadSuggestBox: NSButton!
    @IBOutlet weak var useSourceSerifBox: NSButton!
    @IBOutlet weak var autoLayoutBox: NSButton!
    @IBOutlet weak var promptText: NSTextField!
    @IBOutlet weak var fontSizeSlider: NSSlider!

    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        registerDefaultPrefs()
        loadPrefs()
        updateTextPrompt()
        super.viewDidLoad()
    }
    
    @IBAction func onSliderSlides(_ sender: NSSlider) {
        updateTextPrompt()
    }
    
    @IBAction func OKAndClose(_ sender: NSButton) {
        savePrefs()
        let application = NSApplication.shared
        application.stopModal()
    }
    
    @IBAction func cancelAndClose(_ sender: NSButton) {
        let application = NSApplication.shared
        application.stopModal()
    }
    
    fileprivate func updateTextPrompt() {
        promptText.stringValue = "正文默认字号：\(fontSizeSlider.intValue) 磅"
    }
    
    fileprivate func registerDefaultPrefs() {
        let defaultPreferences: [String: Any] = [
            PreferenceKey.autoLoadSuggest: false,
            PreferenceKey.fontSizePoint: 24,
            PreferenceKey.autoLayout: true,
            PreferenceKey.useSourceSerif: true,
            ]
        userDefaults.register(defaults: defaultPreferences)
    }
    
    fileprivate func loadPrefs() {
        if (userDefaults.bool(forKey: PreferenceKey.autoLoadSuggest)) {
            autoLoadSuggestBox.state = NSControl.StateValue.on
        } else {
            autoLoadSuggestBox.state = NSControl.StateValue.off
        }
        
        if (userDefaults.bool(forKey: PreferenceKey.autoLayout)) {
            autoLayoutBox.state = NSControl.StateValue.on
        } else {
            autoLayoutBox.state = NSControl.StateValue.off
        }
        
        if (userDefaults.bool(forKey: PreferenceKey.useSourceSerif)) {
            useSourceSerifBox.state = NSControl.StateValue.on
        } else {
            useSourceSerifBox.state = NSControl.StateValue.off
        }
        
        fontSizeSlider.intValue = Int32(userDefaults.integer(forKey: PreferenceKey.fontSizePoint))
    }
    
    fileprivate func savePrefs() {
        userDefaults.set(autoLoadSuggestBox.state == NSControl.StateValue.on, forKey: PreferenceKey.autoLoadSuggest)
        userDefaults.set(autoLayoutBox.state == NSControl.StateValue.on, forKey: PreferenceKey.autoLayout)
        userDefaults.set(useSourceSerifBox.state == NSControl.StateValue.on, forKey: PreferenceKey.useSourceSerif)
        userDefaults.set(fontSizeSlider.intValue, forKey: PreferenceKey.fontSizePoint)
    }
}
