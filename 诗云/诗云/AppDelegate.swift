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
    
//    var isServiceCalled = false
//    var serviceQueryText = ""
//    var serviceQueryAuthor = ""
    
    var blurryView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 720, height: 480))

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        blurryView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        blurryView.material = NSVisualEffectView.Material.dark
        blurryView.state = NSVisualEffectView.State.active
        self.window.contentView!.addSubview(blurryView)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

