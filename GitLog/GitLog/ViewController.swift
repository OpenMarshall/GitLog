//
//  ViewController.swift
//  GitLog
//
//  Created by KyXu on 2017/7/14.
//  Copyright © 2017年 KyXu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var projDirField: NSTextField!
    @IBOutlet var authorNameField: NSTextField!
    @IBOutlet var consoleTextView: NSTextView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        projDirField.stringValue = UserDefaults.standard.string(forKey: "ProjectDirectory") ?? ""
        authorNameField.stringValue = UserDefaults.standard.string(forKey: "AuthorName") ?? ""
    }
    
    
    // MARK: - IBAction
    @IBAction func browseDir(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) in
            if result == NSFileHandlingPanelOKButton, let path = openPanel.url?.path {
                self.projDirField.stringValue = path
            }
        }
    }
    
    @IBAction func generate(_ sender: Any) {
        let command = "git•log•--since='7 days ago'•--oneline•--author=\(authorNameField.stringValue)•--pretty=format:* %s"
        let output = cd(projDirField.stringValue).bash(command)
        consoleTextView.string = output
        // save to local
        UserDefaults.standard.set(projDirField.stringValue, forKey: "ProjectDirectory")
        UserDefaults.standard.set(authorNameField.stringValue, forKey: "AuthorName")
    }
    
    @IBAction func copyReport(_ sender: Any) {
        guard let string = consoleTextView.string else {
            return
        }
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(string, forType: NSPasteboardTypeString)
    }
    
}

