//
//  PythonScriptExecutor.swift
//  iOSAnalyticsAutomationTool
//
//  Created by mini02 on 24/09/2019.
//  Copyright © 2019 cragy0516. All rights reserved.
//

import Cocoa
import Foundation

class PythonScriptExecutor: NSObject {
    static let pythonURL = URL(fileURLWithPath: "/usr/local/bin/python3")
    
    static func executeScript(fileName: String) -> (String, String) {
        let task = Process()
        task.executableURL = pythonURL
        
        var path: String
        
        if let tmp_path = Bundle.main.path(forResource: fileName, ofType: "py") {
            path = tmp_path
        } else {
            path = ""
        }
        print ("Execute python script: ", path)
        
        task.arguments = [path]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        do {
            try task.run()
        } catch {
            print (error)
        }
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        let err = String(decoding: errorData, as: UTF8.self)
        
        return (output, err)
    }
    
    static func executeScriptWithArguments(fileName: String, arguments: [String]) -> (String, String) {
        let task = Process()
        task.executableURL = pythonURL
        
        var path: String
        
        if let tmp_path = Bundle.main.path(forResource: fileName, ofType: "py") {
            path = tmp_path
        } else {
            path = ""
        }
        print ("Execute python script: ", path)
        
        var argu = arguments
        argu.insert(contentsOf: [path], at: 0)
        task.arguments = argu
        print ("With arguments:", argu)
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        do {
            try task.run()
        } catch {
            print (error)
        }
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        let err = String(decoding: errorData, as: UTF8.self)
        
        return (output, err)
    }
}
