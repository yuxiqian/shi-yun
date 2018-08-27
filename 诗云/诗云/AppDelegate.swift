//
//  AppDelegate.swift
//  诗云
//
//  Created by 法好 on 2018/8/23.
//  Copyright © 2018 法好. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    
    var blurryView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))

    func searchShiwenPiece() {
        
    }
    
    func searchAuthor() {
        
    }

    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        
        // this is default value but is here for clarity
        blurryView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        
        // set the background to always be the dark blur
        blurryView.material = NSVisualEffectView.Material.dark
        
        // set it to always be blurry regardless of window state
        blurryView.state = NSVisualEffectView.State.active
        
        self.window.contentView!.addSubview(blurryView)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

