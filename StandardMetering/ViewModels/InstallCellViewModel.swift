//
//  InstallCellViewModel.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/12/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class InstallCellViewModel: UITableViewCell {
    
    @IBOutlet weak var lbl_installNumber: UILabel!
    @IBOutlet weak var lbl_syncStatus: UILabel!

    var installNumber: String? {
        didSet {
            if let installNumber = installNumber {
                self.lbl_installNumber!.text = "Install #\(installNumber)"
            } else {
                self.lbl_installNumber!.text = "Nil"
            }
        }
    }
    var syncStatus: String? {
        didSet {
            if let syncStatus = syncStatus {
                self.lbl_syncStatus!.text = syncStatus
            } else {
                self.lbl_syncStatus!.text = "Nil"
            }
        }
    }
}
