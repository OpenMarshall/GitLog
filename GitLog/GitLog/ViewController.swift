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
    
    
    // MARK: - Shell
    func shell(launchPath: String, arguments: [String]) -> String
    {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        task.currentDirectoryPath = projDirField.stringValue
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)!
        if output.characters.count > 0 {
            //remove newline character.
            let lastIndex = output.index(before: output.endIndex)
            return output[output.startIndex ..< lastIndex]
        }
        return output
    }
    
    func bash(command: String, arguments: [String]) -> String {
        let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
        return shell(launchPath: whichPathForCommand, arguments: arguments)
    }
    
    // MARK: - IBAction
    @IBAction func browseDir(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = true
        openPanel.begin { (result) in
            if result == NSFileHandlingPanelOKButton, let path = openPanel.url?.path {
                self.projDirField.stringValue = path
            }
        }
    }
    
    
    @IBAction func generate(_ sender: Any) {
        guard projDirField.stringValue.characters.count != 0 else {
            return
        }
        let log = bash(command: "git", arguments: ["log","--since","'5 days ago'","--oneline",
                                                   "--author",authorNameField.stringValue])
        print(log)
    }
}

