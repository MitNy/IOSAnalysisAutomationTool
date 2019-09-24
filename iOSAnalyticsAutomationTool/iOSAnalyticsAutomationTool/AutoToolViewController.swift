//
//  AutoToolViewController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by cragy0516 on 30/07/2019.
//  Copyright © 2019 cragy0516. All rights reserved.
//

import Cocoa

class AutoToolViewController: NSViewController {
    var device_list: [String]!
    
    @IBOutlet weak var commandListButton: NSPopUpButton!
    @IBOutlet weak var deviceListPopUpButton: NSPopUpButton!
    @IBOutlet weak var appOrPathLabel: NSTextField!
    @IBOutlet weak var logScrollView: NSScrollView!
    
    @IBAction func deviceListButton(_ sender: Any) {
        updateDeviceList()
    }
    
    @IBAction func commandExecute(_ sender: Any) {
        var log: String
        if (commandListButton.selectedItem?.title == "Decompile") {
            if (appOrPathLabel.stringValue == "") {
                log = "[*] No application name"
                print (log)
                logScrollView.insertText(log)
            } else {
                let appName = appOrPathLabel.stringValue
                var output: String
                var err: String
                (output, err) = PythonScriptExecutor.executeScriptWithArguments(fileName: "dump", arguments: [appName, Bundle.main.resourcePath!])
                print ("Done.")
                print (output)
                print (err)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        updateDeviceList()
    }
    
    func updateDeviceList() {
        deviceListPopUpButton.removeAllItems()
        
        var output: String
        var err: String
        
        (output, err) = PythonScriptExecutor.executeScript(fileName: "find_device")
        if !output.isEmpty {
            print ("Found device\n", output)
            /* To-do: must re-factory this freakin' code
             *
             * let result = output.components(separatedBy: ["=",",","(",")"])
             * let id = result[2]
             * let name = result[4]
             * let type = result[6]
             */

            deviceListPopUpButton.addItem(withTitle: output)
        }
    }
    
}
