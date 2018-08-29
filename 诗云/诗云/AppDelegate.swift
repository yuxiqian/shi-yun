//
//  AppDelegate.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/23.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    @IBOutlet weak var showAuthorMenuButton: NSMenuItem!
    @IBOutlet weak var showAuthorInfoButton: NSMenuItem!
    //    var isServiceCalled = false
//    var serviceQueryText = ""
//    var serviceQueryAuthor = ""
    
    var blurryView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 720, height: 480))

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func setAuthorMenu(_ authorName: String = "") {
        if authorName == "" {
            showAuthorMenuButton.isEnabled = false
            showAuthorInfoButton.isEnabled = false
            showAuthorMenuButton.title = "检索所有此作者的诗文"
            showAuthorInfoButton.title = "检索此作者的信息"
        } else {
            showAuthorMenuButton.isEnabled = true
            showAuthorInfoButton.isEnabled = true
            showAuthorMenuButton.title = "检索所有「\(authorName)」的诗文"
            showAuthorInfoButton.title = "检索「\(authorName)」的信息"
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        blurryView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        blurryView.material = NSVisualEffectView.Material.dark
        blurryView.state = NSVisualEffectView.State.active
        self.window.contentView!.addSubview(blurryView)
        setAuthorMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

