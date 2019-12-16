//
//  MemoryDumpViewController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by 이미진 on 20/11/2019.
//  Copyright © 2019 cragy0516. All rights reserved.
//

import Cocoa
import Foundation

class MemoryDumpViewController: NSViewController {
    @IBOutlet weak var deviceListPopupButton: NSPopUpButton!
    @IBOutlet weak var processNameTextField: NSTextField!
    @IBOutlet weak var logScrollView: NSScrollView!
    
    @IBOutlet weak var tableView: NSTableView!
    
    var data: [processData] = []
    
    @IBAction func deviceListButton(_ sender: Any) {
        updateDeviceList()
    }
    @IBAction func fridaServerInstallButton(_ sender: Any) {
        let tmp_path = Bundle.main.path(forResource: "frida-server-12.7.22-ios-arm64", ofType: nil)!
        PythonScriptExecutor.executeScriptWithArguments(fileName: "do_scp", arguments: [tmp_path, "/var/root"])
        PythonScriptExecutor.executeScriptWithArguments(fileName: "do_ssh", arguments: ["chmod +x frida-server-12.7.22-ios-arm64"])
        PythonScriptExecutor.executeScriptWithArguments(fileName: "do_ssh", arguments: ["mv frida-server-12.7.22-ios-arm64 /usr/sbin/frida-server"])
    }
    @IBAction func fridaServerStartButton(_ sender: Any) {
        PythonScriptExecutor.executeScriptWithArguments(fileName: "do_ssh", arguments: ["/usr/sbin/frida-server"])
    }
    @IBAction func processListButton(_ sender: Any) {
        data = []
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", "/usr/local/bin/frida-ps -U")]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            let result_lines = result.components(separatedBy: "\n")
            for i in 2..<result_lines.count {
                let parsed_data = result_lines[i].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "  ")
                if parsed_data.count > 1 {
                    let process_data = processData(PID: parsed_data[0], Name: parsed_data[1])
                    data.append(process_data)
                }
            }
        }
        else {
            print ("err")
        }
        print(data)
        self.tableView.reloadData()
    }
    @IBAction func memoryDumpButton(_ sender: Any) {
        let process_name = processNameTextField.stringValue
        PythonScriptExecutor.executeScriptWithArguments(fileName: "fridump", arguments: ["-U", "-o", "/Users/mitny/Desktop/zolp/dump", process_name])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDeviceList()
    }
    
    override func viewDidAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLog(_notifiction:)),
                                               name: NSNotification.Name(rawValue: "DumperLogSender"), object: nil)
    }
    
    override func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DumperLogSender"), object: nil)
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
        deviceListPopupButton.removeAllItems()
        
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

            deviceListPopupButton.addItem(withTitle: output)
        }
    }
    
}


extension MemoryDumpViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
}

extension MemoryDumpViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print(tableColumn!.identifier)
        let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        let asset = data[row]
        if (tableColumn?.identifier)!.rawValue == "PIDCellID" {
            cellView.textField!.stringValue = asset.PID
        }
        else if (tableColumn?.identifier)!.rawValue == "ProcessNameCellID" {
            cellView.textField!.stringValue = asset.Name
        }
        
        return cellView
    }
}
