//
//  HashCheckViewController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by cragy0516 on 30/07/2019.
//  Copyright © 2019 cragy0516. All rights reserved.
//

import Cocoa

class HashCheckViewController: NSViewController {
    @IBOutlet weak var ContainerView: NSView!
    @IBOutlet weak var Original_HashCheck: NSTextFieldCell?
    @IBOutlet weak var Signed_HashCheck: NSTextFieldCell?
    @IBOutlet weak var Original_FilePath: NSTextField!
    @IBOutlet weak var Signed_FilePath: NSTextField!
    @IBOutlet weak var EqualCheck: NSTextField!
    
    @IBOutlet weak var fileExtract_path: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func HashCheckBtnClick(_ sender: Any) {
        if ( Original_FilePath!.stringValue != "" ) {
            let original_file = Original_FilePath.stringValue
            Original_HashCheck?.stringValue = HashCheckController().SHA256Hash(filePath: original_file)
        }
        if( Signed_FilePath!.stringValue != "" ) {
            let signed_file = Signed_FilePath.stringValue
            Signed_HashCheck?.stringValue = HashCheckController().SHA256Hash(filePath: signed_file)
        }
        
        if( (Original_HashCheck?.stringValue == Signed_HashCheck?.stringValue) && (Original_HashCheck?.stringValue != "") && (Signed_HashCheck?.stringValue != "") ) {
            EqualCheck?.stringValue = "=="
        }
        else if ( (Original_HashCheck?.stringValue == "") || (Signed_HashCheck?.stringValue == "") ) {
        }
        else {
            EqualCheck?.stringValue = "!="
        }
    }
    
    @IBAction func Original_FileOpen(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose Original file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["txt"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                Original_FilePath.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func Signed_FileOpen(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose Signed file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                Signed_FilePath.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func ResetBtn(_ sender: Any) {
        EqualCheck?.stringValue = ""
        Original_FilePath.stringValue = ""
        Signed_FilePath.stringValue = ""
        Original_HashCheck?.stringValue = ""
        Signed_HashCheck?.stringValue = ""
        
    }
    
    @IBAction func fileExtract_directory(_ sender: Any) {
        fileExtractController().select_directory()
    }
    
    
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (data.count)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        let asset = data[row]
        if (tableColumn?.identifier)!.rawValue == "Filename" {
            cellView.textField!.stringValue = asset.Filename
        }
        else if (tableColumn?.identifier)!.rawValue == "Size" {
            cellView.textField!.stringValue = asset.Size
        }
        else if (tableColumn?.identifier)!.rawValue == "Hash" {
            cellView.textField!.stringValue = asset.Hash
        }
        
        return cellView
    }
    
}
