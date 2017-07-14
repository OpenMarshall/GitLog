//
//  Shell.swift
//  GitLog
//
//  Created by 徐开源 on 2017/7/14.
//  Copyright © 2017年 KyXu. All rights reserved.
//

import Foundation

struct Shell {
    var directoryPath: String! = "/usr"
    
    fileprivate func shell(launchPath: String, arguments: [String]) -> String {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        task.currentDirectoryPath = self.directoryPath
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8), output.characters.count > 0 {
            // remove newline character
            let lastIndex = output.index(before: output.endIndex)
            return output[output.startIndex ..< lastIndex]
        }else {
            return ""
        }
    }
    
    func bash(command: String, arguments: [String]) -> String {
        let whichPathForCommand = shell(launchPath: "/bin/bash",
                                        arguments: [ "-l", "-c", "which \(command)" ])
        return shell(launchPath: whichPathForCommand,
                     arguments: arguments)
    }
}


func cd(_ directoryPath: String) -> Shell {
    return Shell(directoryPath: directoryPath)
}
