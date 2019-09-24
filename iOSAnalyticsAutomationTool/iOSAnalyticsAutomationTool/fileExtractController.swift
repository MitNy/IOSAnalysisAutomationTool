//
//  fileExtractController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by 이미진 on 13/06/2019.
//  Copyright © 2019 이미진. All rights reserved.
//

import Cocoa

class fileExtractController: NSTableViewRowAction {

    func select_directory() {
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose Original file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: path)
                    print(files)
                } catch {
                    print(error)
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
}
