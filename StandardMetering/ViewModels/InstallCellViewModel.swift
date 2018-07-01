//
//  InstallCellViewModel.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/12/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class InstallCellViewModel: UITableViewCell {
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    // Used to set the install number safely
    var installNumber: String? {
        didSet {
            if let installNumber = installNumber {
                self.lbl_installNumber!.text = "Install #\(installNumber)"
            } else {
                self.lbl_installNumber!.text = "Nil"
            }
        }
    }
    
    // Used to set the sync status safely
    var syncStatus: String? {
        didSet {
            if let syncStatus = syncStatus {
                self.lbl_syncStatus!.text = syncStatus
            } else {
                self.lbl_syncStatus!.text = "Nil"
            }
        }
    }
    
    @IBOutlet weak var lbl_installNumber: UILabel!
    @IBOutlet weak var lbl_syncStatus: UILabel!
    
    var install: InstallEntity? {
        didSet {
            
            // Ensure install was not set to nil
            guard let install = install else {
                
                self.lbl_installNumber!.textColor = .black
                self.lbl_installNumber!.text = "Nil"
                
                self.lbl_syncStatus!.textColor = .black
                self.lbl_syncStatus!.text = "Nil"
                
                return;
            }
            
            // Set install number label
            if let installNum = install.install_num {
                self.lbl_installNumber!.text = "Install #\(installNum)"
            }
            
            // Set sync status
            if install.sync_status {
                self.lbl_syncStatus!.textColor = .forrestGreen
                self.lbl_syncStatus!.text = syncCompleteText
            } else {
                self.lbl_syncStatus!.textColor = .red
                self.lbl_syncStatus!.text = syncNeededText
            }
        }
    }
    
    
    
}
