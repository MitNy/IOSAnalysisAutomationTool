//
//  FileExtractViewController.swift
//  iOSAnalyticsAutomationTool
//
//  Created by cragy0516 on 30/07/2019.
//  Copyright © 2019 cragy0516. All rights reserved.
//

import Cocoa

class FileExtractViewController: NSViewController {
    @IBOutlet var fileExtract_table: NSTableView!
    
    var data : [fileExtractData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let data1 = fileExtractData.init(Filename: "test1", Size: "1234", Hash: "asdadsafad123")
        let data2 = fileExtractData.init(Filename: "test2", Size: "44", Hash: "5123010adasdasd")
        let data3 = fileExtractData.init(Filename: "test3", Size: "111", Hash: "asdqoe1234")
        data.append(data1)
        data.append(data2)
        data.append(data3)
        
        self.fileExtract_table?.reloadData()
    }
    
}
