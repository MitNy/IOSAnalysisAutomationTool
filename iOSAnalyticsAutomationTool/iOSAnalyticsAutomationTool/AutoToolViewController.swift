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
        var logString: String
        if (commandListButton.selectedItem?.title == "Decompile") {
            if (appOrPathLabel.stringValue == "") {
                logString = "[*] No application name\n"
                print (logString)
                DispatchQueue.main.async {
                    let textView = self.logScrollView.documentView as? NSTextView
                    textView?.isEditable = true
                    self.logScrollView.documentView!.insertText("")
                    textView?.string = textView!.string + logString
                    textView?.isEditable = false
                }
            } else {
                let appName = appOrPathLabel.stringValue
                var output: String
                var err: String
                (output, err) = PythonScriptExecutor.executeScriptWithArguments(fileName: "dump", arguments: [appName, Bundle.main.resourcePath!])
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        updateDeviceList()
    }
    
    override func viewDidAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLog(_notifiction:)),
                                               name: NSNotification.Name(rawValue: "AutoToolLogSender"), object: nil)
    }
    
    override func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AutoToolLogSender"), object: nil)
        DispatchQueue.main.async {
            let textView = self.logScrollView.documentView as? NSTextView
            textView?.isEditable = true
            textView?.string = ""
            textView?.isEditable = false
        }
    }
    
    @objc func updateLog(_notifiction: Notification) {
        guard let logString = _notifiction.userInfo?["logString"] as? String else { return }
        print("[log]", logString)
        DispatchQueue.main.async {
            let textView = self.logScrollView.documentView as? NSTextView
            textView?.isEditable = true
            self.logScrollView.documentView!.insertText("")
            //self.logScrollView.scrollsDynamically = true
            textView?.string = textView!.string + logString
            textView?.isEditable = false
        }
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
