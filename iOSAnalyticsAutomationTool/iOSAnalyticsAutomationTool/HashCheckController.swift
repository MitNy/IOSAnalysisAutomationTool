//
//  HashCheckController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by 이미진 on 11/06/2019.
//  Copyright © 2019 이미진. All rights reserved.
//

import Cocoa

class HashCheckController: NSTabViewItem {
    func SHA256Hash(filePath: String)->String{
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            let fileData = try Data.init(contentsOf: fileURL)
            let fileBytes = fileData.bytes
            let hash = fileBytes.sha256()
            return hash.toHexString()
            
        } catch {
            print(error)
        }
        return "Error"
    }
    
}
