//
//  FunctionHookViewController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by 이미진 on 25/09/2019.
//  Copyright © 2019 cragy0516. All rights reserved.
//

import Cocoa

class FunctionHookViewController: NSViewController {
    @IBOutlet weak var processNameTextField: NSTextField!
    @IBOutlet weak var jsFileTextField: NSTextField!
    @IBOutlet weak var logScrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLog(_notifiction:)),
                                               name: NSNotification.Name(rawValue: "HookingLogSender"), object: nil)
    }
    
    override func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HookingLogSender"), object: nil)
        DispatchQueue.main.async {
            let textView = self.logScrollView.documentView as? NSTextView
            textView?.isEditable = true
            textView?.string = ""
            textView?.isEditable = false
        }
    }
    
    @IBAction func processListButtonClicked(_ sender: Any) {
        var output: String
        var err: String
        (output, err) = PythonScriptExecutor.executeScriptWithArguments(fileName: "dump", arguments: ["noappnamelikethis-goodjob", Bundle.main.resourcePath!])
        print (output)
    }
    @IBAction func jsFileOpenButtonClicked(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Select your JavaScript file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["js"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                jsFileTextField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    @IBAction func hookingStartButtonClicked(_ sender: Any) {
        let process_name = processNameTextField.stringValue
        let javascript_path = jsFileTextField.stringValue
        
        var output: String
        var err: String
        (output, err) = PythonScriptExecutor.executeScriptWithArguments(fileName: "hooking", arguments: [process_name, javascript_path])
        print (output, err)
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
    
}
