//
//  PoemStruct.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/24.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation

class Poem : NSObject {
    var title: String = "静夜思"
    var author: String = "李白"
    var dynasty: String = "唐代"
    var content: String = "床前明月光，疑是地上霜。举头望明月，低头思故乡。"
    init (Title: String, Author: String, Dynasty: String, Content: String) {
        if (!Title.starts(with: "「")) {
            self.title = "「" + Title + "」"
        } else {
            self.title = Title
        }
        self.author = Author
        self.dynasty = Dynasty
        self.content = Content
//        NSLog("生成poem对象，\(title) \(author) \(dynasty) \(content)")
    }
}
