//
//  WindowController.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/27.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import Cocoa


class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return contentViewController?.makeTouchBar()
    }
}
