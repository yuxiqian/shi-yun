//
//  ViewController.swift
//  诗云
//
//  Created by yuxiqian on 2018/8/23.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa
import Kanna

class ViewController: NSViewController, NSTouchBarDelegate {
    
    var isAutoSuggest = false


    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.wantsLayer = true
        
        tableView.delegate = self
        tableView.dataSource = self
        loadingIcon.isHidden = true
        loadingIcon.startAnimation(self)
        
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        let sortByTitle = NSSortDescriptor(key: "sortByTitle", ascending: true)
        let sortByAuthor = NSSortDescriptor(key: "sortByAuthor", ascending: true)
        let sortByDynasty = NSSortDescriptor(key: "sortByDynasty", ascending: true)
        let sortByContent = NSSortDescriptor(key: "sortByContent", ascending: true)
        
        tableView.tableColumns[0].sortDescriptorPrototype = sortByTitle
        tableView.tableColumns[1].sortDescriptorPrototype = sortByAuthor
        tableView.tableColumns[2].sortDescriptorPrototype = sortByDynasty
        tableView.tableColumns[3].sortDescriptorPrototype = sortByContent
        updateSettings()
        if (isAutoSuggest) {
            loadTodaySuggest(self)
        }
//        loadMoreButton.isHidden = true
    }
    
    func updateSettings() {
        let userDefaults = UserDefaults.standard
        isAutoSuggest = userDefaults.bool(forKey: PreferenceKey.autoLoadSuggest)
    }

    @IBOutlet weak var pieceTextField: NSSearchField!
    @IBOutlet weak var searchButton: NSButton!
    @IBOutlet weak var popUpSelector: NSPopUpButton!
    //    @IBOutlet var tempHTMLPlaceHolder: NSTextView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var loadingIcon: NSProgressIndicator!
    @IBOutlet weak var loadProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var statusBar: NSTextField!
    
    
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [NSTouchBarItem.Identifier("searchText"), NSTouchBarItem.Identifier("searchContext"), NSTouchBarItem.Identifier("searchAuthor"),
            NSTouchBarItem.Identifier("Separator"),NSTouchBarItem.Identifier("loadSuggest")]
        return touchBar
    }
    

    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
        switch identifier {
        case NSTouchBarItem.Identifier("searchText"):
            touchBarItem.view = NSTextField(labelWithString: "  搜索  ")
            break
        case NSTouchBarItem.Identifier("searchContext"):
            touchBarItem.view = NSButton(title: "🔍 诗文", target: self, action: #selector(touchBarSearchContext(_:)))
            break
        case NSTouchBarItem.Identifier("searchAuthor"):
            touchBarItem.view = NSButton(title: "🔎 作者", target: self, action: #selector(touchBarSearchAuthor(_:)))
            break
        case NSTouchBarItem.Identifier("Separator"):
            touchBarItem.view = NSTextField(labelWithString: "      ")
            break
        case NSTouchBarItem.Identifier("loadSuggest"):
            touchBarItem.view = NSButton(title: "❤️ 推荐", target: self, action: #selector(loadTodaySuggest(_:)))
            break
        default:
            touchBarItem.view = NSButton(title: "defaultButton", target: self, action: nil)
            break
        }
        return touchBarItem
    }
    
    @objc func touchBarSearchContext(_ sender: NSButton) {
        self.popUpSelector.selectItem(at: 0)
        self.searchButtonPressed(searchButton)
    }
    
    @objc func touchBarSearchAuthor(_ sender: NSButton) {
        self.popUpSelector.selectItem(at: 1)
        self.searchButtonPressed(searchButton)
    }
    
    func updateLoadProgress(_ progress: Double) {
        NSLog("Value: \(progress)")
        self.loadProgressIndicator.doubleValue = progress * 100
    }
    
    @IBAction func goToWebsite(_ sender: NSButton) {
        if let url = URL(string: "https://www.gushiwen.org"), NSWorkspace.shared.open(url) {
            // successfully opened
        }
    }
    
    @IBAction func loadTodaySuggest(_ sender: Any) {
        loadToTheEnd = true
        globalQueue.suspend()
        poemArray.removeAll()
        loadingIcon.isHidden = false
        self.disableUI()
        maxPageCount = 1
        globalQueue.async {
            self.loadSuggestPoem("http://www.gushiwen.org/")
            self.refreshTableView()
            DispatchQueue.main.async(execute: {
                self.searchButton.isEnabled = true
                self.popUpSelector.isEnabled = true
                self.loadingIcon.isHidden = true
                if self.poemArray.count == 0 {
                    self.showErrorMessage(errorMsg: "未能加载今日推荐诗歌。\n\n检查你的网络连接并重试。")
                }
            })
        }
    }


    
    var maxPageCount = 1
    var poemArray: [Poem?] = []
    let globalQueue = DispatchQueue.global()
    var loadToTheEnd = true
    
    func writeLog(_ log: String) {
        NSLog(log)
    }
    
    
    func showErrorMessage(errorMsg: String) {
        //        self.writeLog("出错：\(errorMsg)")
        let errorAlert: NSAlert = NSAlert()
        errorAlert.messageText = errorMsg
        errorAlert.alertStyle = NSAlert.Style.critical
        errorAlert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    func sortArray(_ sortKey: String, _ isAscend: Bool) {
        if (poemArray.count == 0) {
            return
        }
        var sortComment = "按照"
        switch(sortKey) {
        case "sortByTitle":
            globalQueue.async {
                func titleSorter(p1: Poem?, p2: Poem?) -> Bool {
                    return stringCompare(comparedStringOne: p1!.title, comparedStringTwo: p2!.title, isAscend: isAscend)
                }
                self.poemArray.sort(by: titleSorter)
                self.refreshTableView()
            }
            sortComment += "标题"
            break
        case "sortByAuthor":
            globalQueue.async {
                func authorSorter(p1: Poem?, p2: Poem?) -> Bool {
                    return stringCompare(comparedStringOne: p1!.author, comparedStringTwo: p2!.author, isAscend: isAscend)
                }
                self.poemArray.sort(by: authorSorter)
                self.refreshTableView()
            }
            sortComment += "作者"
            break
        case "sortByDynasty":
            globalQueue.async {
                func dynastySorter(p1: Poem?, p2: Poem?) -> Bool {
                    return stringCompare(comparedStringOne: p1!.dynasty, comparedStringTwo: p2!.dynasty, isAscend: isAscend)
                }
                self.poemArray.sort(by: dynastySorter)
                self.refreshTableView()
            }
            sortComment += "朝代"
            break
        case "sortByContent":
            globalQueue.async {
                func contentSorter(p1: Poem?, p2: Poem?) -> Bool {
                    return stringCompare(comparedStringOne: p1!.content, comparedStringTwo: p2!.content, isAscend: isAscend)
                }
                self.poemArray.sort(by: contentSorter)
                self.refreshTableView()
            }
            sortComment += "内容"
            break
        case "badSortArgument":
            showErrorMessage(errorMsg: "排序参数出错。")
            sortComment += "未知参数"
            break
        default:
            break
        }
        if (isAscend) {
            sortComment += "降序排序"
        } else {
            sortComment += "升序排序"
        }
        sortComment += "了 \(poemArray.count) 首诗。"
        self.statusBar.stringValue = sortComment
    }

    
    func disableUI() {
//        pieceTextField.isEnabled = false
        searchButton.isEnabled = false
        popUpSelector.isEnabled = false
        loadingIcon.isHidden = false
        loadProgressIndicator.isHidden = false
        statusBar.stringValue = ""
    }
    
    func refreshTableView() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func resumeUI(isSuggestMode: Bool = false) {
//        pieceTextField.isEnabled = true
        searchButton.isEnabled = true
        popUpSelector.isEnabled = true
        loadingIcon.isHidden = true
        loadProgressIndicator.isHidden = true
        if poemArray.count == 0 && (!isSuggestMode) {
            showErrorMessage(errorMsg: "没有找到包含“\(pieceTextField.stringValue)”的\(popUpSelector.selectedItem?.title ?? """
                内容。
                """)。\n\n检查关键字设定和网络连接并重试。")
        } else {
            statusBar.stringValue = "已成功加载 \(poemArray.count) 首诗。"
        }
    }
    
    func addTableItem(toBeAdded poemObj: Poem) {
        if poemArray.count <= 1000 {
            poemArray.append(poemObj)
        } else {
            globalQueue.suspend()
        }
//        tableView.reloadData()
    }
    
    @IBAction func popUpSelected(_ sender: NSPopUpButton) {
        pieceTextField.placeholderString = "输入" + (popUpSelector.selectedItem?.title)!
    }
    
//    func addItemIntoList(_ str: String) {
//        resultTableView.insertRow(at: resultTableView.numberOfRows, withAnimation: NSTableView.AnimationOptions.slideUp)
//    }

    
    @IBAction func searchButtonPressed(_ sender: NSButton) {
        if (pieceTextField.stringValue.isEmpty) {
//            tempHTMLPlaceHolder.string = ""
            if (!loadToTheEnd) {
                loadToTheEnd = true
                writeLog("终止加载")
            } else {
                writeLog("空搜索内容，不发起请求")
            }
            return
        }
        poemArray.removeAll()
        disableUI()
//        loadMoreButton.isHidden = false
        loadingIcon.isHidden = false
        maxPageCount = 1
        // title
        // author
        // guwen
        var searchType = ""
        loadToTheEnd = false
        switch popUpSelector.selectedItem?.title {
        case "作者":
            searchType = "author"
            writeLog("匹配到标记：搜索作者")
            break
        case "古籍":
            searchType = "guwen"
            writeLog("匹配到标记：搜索古籍")
            break
        case "诗文":
            searchType = "title"
            writeLog("匹配到标记：搜索诗文")
            break
        default:
            writeLog("啥也没匹配到。")
            return
        }
//        https://so.gushiwen.org/search.aspx?type=title&page=80&value=wwww
//        var eachLoadPages = 1
//        while (eachLoadPages < 3) {
//            let rawRequestUrl: NSString = "https://so.gushiwen.org/search.aspx?type=\(searchType)&page=\(self.currentLoadPageNum)&value=\(self.pieceTextField.stringValue)" as NSString
//            let requestUrl: String = rawRequestUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "https://so.gushiwen.org/search.aspx"
//            //        NSLog(requestUrl)
//            globalQueue.async {
//                self.startSession(sessionUrl: requestUrl)
//            }
//            eachLoadPages += 1
//        }
        let requestKeyWord = self.pieceTextField.stringValue
        globalQueue.async {
            self.loadAllTheRest(requestKeyWord.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "https://so.gushiwen.org/search.aspx", searchType, 1)
        }
//        if (directoryItems.count == 0) {
//            self.writeLog("检索失败。检查你的关键字。")
//            let errorAlert: NSAlert = NSAlert()
//            errorAlert.messageText = "没有找到包含“\(pieceTextField.stringValue)”的\(popUpSelector.selectedItem?.title ?? """
//            内容
//            """)。"
//            errorAlert.alertStyle = NSAlert.Style.critical
//            errorAlert.beginSheetModal(for: self.view.window!, completionHandler: nil)
//        }
//        tempHTMLPlaceHolder.stringValue = HTMLString! as String
//        NSURLConnection.sendAsynchronousRequest()
//        while (tempHTMLPlaceHolder.stringValue.isEmpty) {
//
//        }
//        resumeUI()
    }
    
    func loadSuggestPoem(_ requestUrl: String) {
        self.startSession(sessionUrl: "https://www.gushiwen.org/", true)
        DispatchQueue.main.async(execute: {
            self.resumeUI(isSuggestMode: true)
        })
    }
    
    func startSession(sessionUrl requestUrl: String, _ isSuggestMode: Bool) {
        let URLData = NSData(contentsOf: NSURL(string: requestUrl)! as URL)
        if URLData == nil {
            self.writeLog("网络连接出错。")
//            let errorAlert: NSAlert = NSAlert()
//            errorAlert.messageText = "网络连接出错。"
//            errorAlert.alertStyle = NSAlert.Style.critical
//            errorAlert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            loadToTheEnd = true
            return
        }
        var html: String = ""
        html = NSString(data: URLData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        writeLog("得到 HTML 代码\(html.prefix(30))...")
        if html.contains("<b>未搜索到“") && html.contains("”相关资料</b>") {
            loadToTheEnd = true
        }
        if let parsedDoc = try? HTML(html: html, encoding: .utf8) {
            var flag = true
            var cleanPoemList: [String] = []
            for maxPage in parsedDoc.xpath("//*[@id=\"FromPage\"]/div/span[1]") {
                let maxPageString = (maxPage.text)?.replacingOccurrences(of: "/ ", with: "").replacingOccurrences(of: "页", with: "")
                
                if (maxPageString?.contains("+") ?? false) {
                    maxPageCount = 100
                } else {
                    if let number = Int(maxPageString ?? "1"){
                        maxPageCount = number
                    }
                }
//                NSLog("得到最大页 HTML\(maxPageString ?? "nothing")")
            }
            for node in parsedDoc.css(".main3 .cont") {
                cleanPoemList.removeAll()
//                writeLog("Gotta " + node.text!)
                let piece = node.text!
//                NSLog("Full parsed piece: \(node.text!)\n------------------------\n")
                let parsedPoem = piece.components(separatedBy: NSCharacterSet(charactersIn:"\n：") as CharacterSet)
                let whitespace = NSCharacterSet.whitespacesAndNewlines
                for i in parsedPoem {
                    if (isIncludeChineseIn(string: i)) {
                        cleanPoemList.append(i.trimmingCharacters(in: whitespace))
//                        NSLog("干净的：\(i)")
                    }
                }
//                NSLog("得到的长度是\(cleanPoemList.count)")
//                NSLog("现在cleanPoemList = \(cleanPoemList[1])")
                if (cleanPoemList.count < 4) {
                    continue
                }
                if !(cleanPoemList[1].contains("代") ||
                    cleanPoemList[1].contains("朝") ||
                    cleanPoemList[1].contains("先秦") ||
                    cleanPoemList[1].contains("魏晋") ||
                    cleanPoemList[1].contains("两汉") ||
                    cleanPoemList[1].contains("未知")) {
//                    NSLog("Dropped ones:\(cleanPoemList[1])")
                    continue
                }
                if (cleanPoemList.count > 4) {
                    var id: Int = 3;
                    while(id < cleanPoemList.count) {
                        cleanPoemList[3] += cleanPoemList[id]
                        id += 1
                    }
                }
                addTableItem(toBeAdded: Poem(Title: cleanPoemList[0], Author: cleanPoemList[2], Dynasty: cleanPoemList[1], Content: cleanPoemList[3]))
                flag = false
//                writeLog("---------------------------")
            }
            if flag {
//                writeLog("Gotta nothing to be parsed.")
            }
        }
    }
    
    func loadAllTheRest(_ searchKeyword: String, _ searchType: String, _ loadInPage: Int) {
        let requestUrl: String = "https://so.gushiwen.org/search.aspx?type=\(searchType)&page=\(loadInPage)&value=\(searchKeyword)"
        self.startSession(sessionUrl: requestUrl, false)
        DispatchQueue.main.async(execute: {
            self.updateLoadProgress(Double(loadInPage) / Double(self.maxPageCount))
        })
        if (maxPageCount >= loadInPage) {
            //        NSLog(requestUrl)
            
//            NSLog("Now im at \(loadInPage)")
            //        if (loadInPage % 5 == 0) {
            refreshTableView()
            //        }？
            if !loadToTheEnd {
                loadAllTheRest(searchKeyword, searchType, loadInPage + 1)
//                NSLog("Now!!!!!!!!!!loadtotheend = \(loadToTheEnd)")
            }
        }
        DispatchQueue.main.async(execute: {
            self.resumeUI()
        })
    }

    @IBAction func onPressEnter(_ sender: NSSearchField) {
        searchButtonPressed(searchButton)
    }
    
    override var representedObject: Any? {
        didSet {
//            resumeUI()
        }
    }
    

    
    func updateStatusBar() {
        guard tableView.selectedRow >= 0,
            let selectedItem = poemArray[tableView.selectedRow] else {
                self.statusBar.stringValue = ""
                return
        }
        self.statusBar.stringValue = "选中了\(selectedItem.dynasty)\(selectedItem.author)的作品\(selectedItem.title)。"
    }
}


extension ViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return poemArray.count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
//        NSLog(sortDescriptor.key ?? "badSortArgument")
//        NSLog("now ascending == \(sortDescriptor.ascending)")
        sortArray(sortDescriptor.key ?? "badSortArgument", !sortDescriptor.ascending)
    }
}

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let titleCell = "titleCell"
        static let authorCell = "authorCell"
        static let dynastyCell = "dynastyCell"
        static let contentCell = "contentCell"
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateStatusBar()
    }
    
    func tableView(_ tableView: NSTableView, viewFor
        tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var displayText: String = "Placeholder"
        var cellIdentifier: String = ""
        
        let item = poemArray[row]
//        NSLog("....gotta item has some propterties...");
        if tableColumn == tableView.tableColumns[0] {
            displayText = item!.title
            cellIdentifier = CellIdentifiers.titleCell
        } else if tableColumn == tableView.tableColumns[1] {
            displayText = item!.author
            cellIdentifier = CellIdentifiers.authorCell
        } else if tableColumn == tableView.tableColumns[2] {
            displayText = item!.dynasty
            cellIdentifier = CellIdentifiers.dynastyCell
        } else if tableColumn == tableView.tableColumns[3] {
            displayText = item!.content
            cellIdentifier = CellIdentifiers.contentCell
        }
//        NSLog("填入文字\(displayText)")
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = displayText
            return cell
        }
        return nil
    }
    
    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        updateSettings()
        guard tableView.selectedRow >= 0,
            let selPoem = poemArray[tableView.selectedRow] else {
                return
        }
//        NSLog("Selpoem has...\(selPoem.title), \(selPoem.author), \(selPoem.dynasty), \(selPoem.content),")
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let poemDetailWindowController = storyboard.instantiateController(withIdentifier: "Poem Detail Window Controller") as! NSWindowController
            
        if let poemDetailWindow = poemDetailWindowController.window {
            let poemDetailViewController = poemDetailWindow.contentViewController as! PoemDetailViewController
            poemDetailViewController.poemTitle = selPoem.title
            poemDetailViewController.poemAuthor = selPoem.author
            poemDetailViewController.poemDynasty = selPoem.dynasty
            poemDetailViewController.poemContent = selPoem.content
//            let application = NSApplication.shared
//            application.runModal(for: poemDetailWindow)
//            poemDetailWindow.close()
            poemDetailWindow.title = "\(selPoem.title)-  [\(selPoem.dynasty)] \(selPoem.author)"
            poemDetailWindowController.showWindow(nil)
        }
    }
}

