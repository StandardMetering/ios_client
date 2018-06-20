//
//  MasterViewModel.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/12/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//
// Description:
//   Used to compartmentaize data for each table section.
//
class TableSectionItem {
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    var title: String
    var index: Int
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Initialization
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Sets relevant fields
    //
    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
}

// -----------------------------------------------------------------------------------------------------------------
// MARK: - Global Constants
// -----------------------------------------------------------------------------------------------------------------

let syncActionItem = TableSectionItem(title: "", index: 0)
let incompleteInstallItem = TableSectionItem(title: "Incomplete Installs", index: 1)
let completeInstallItem = TableSectionItem(title: "Complete Installs", index: 2)
let profileActionsItem = TableSectionItem(title: "Profile Actions", index: 3)

// TODO: Github issue #5
let tableSectionTitles = [
    syncActionItem,
    incompleteInstallItem,
    completeInstallItem,
    profileActionsItem
]


class MasterViewModel: NSObject, UITableViewDataSource {
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    private let masterViewController: MasterViewController
    
    private var completeInstalls = [InstallEntity?]()
    private var incompleteInstalls = [InstallEntity?]()
    private let profileActions = [
        "Manage Users", // TODO: Admin Only
        "Sign Out"
    ]
    
    
    //
    // Description:
    //   Intialize module
    //
    init(master masterViewController: MasterViewController) {
        self.masterViewController = masterViewController
        
        incompleteInstalls.append(nil)
        incompleteInstalls.append(nil)
        incompleteInstalls.append(nil)
        
        completeInstalls.append(nil)
        completeInstalls.append(nil)
    }
    
    
    //
    // Description:
    //   Return the number of sections in the table view
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionTitles.count
    }
    
    
    //
    // Description:
    //   Returns the title text of each section
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionTitles[ section ].title
    }
    
    
    //
    // Description:
    //   Returns the number of cells in a given table view section
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case syncActionItem.index:
            return 1
        case incompleteInstallItem.index:
            return self.incompleteInstalls.count + 1
        case completeInstallItem.index:
            return self.completeInstalls.count
        case profileActionsItem.index:
            return self.profileActions.count
        default:
            return 0
        }
    }
    
    
    //
    // Description:
    //   Returns a cell for a given index path
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case syncActionItem.index:
            let cell = self.masterViewController.tableView.dequeueReusableCell(withIdentifier: "SyncActionsCellModel") as! SyncActionsCellModel
        
            cell.backgroundColor = .clear
            
            return cell
        default:
            let cell = self.masterViewController.tableView.dequeueReusableCell(withIdentifier: "InstallCellViewModel") as! InstallCellViewModel
            
            initCell(cell)
            configureInstallCell(cell, atIndexPath: indexPath)
            
            return cell
        }
        
        
    }
    
    
    //
    // Description:
    //   Utility function meant to initialize cell to standard state before manipulating
    //
    func initCell(_ cell: InstallCellViewModel ) {
        
        cell.lbl_installNumber.isHidden = false
        cell.lbl_installNumber.textColor = .black
        
        cell.lbl_syncStatus.isHidden = false
        cell.lbl_syncStatus.textColor = .black
    }
    
    
    //
    // Description:
    //   Configure given install cell to display correct information
    //
    func configureInstallCell(_ cell: InstallCellViewModel, atIndexPath indexPath: IndexPath) {
        
        switch indexPath.section {
        case incompleteInstallItem.index:

            if indexPath.row == 0 {
                
                cell.lbl_installNumber.text = "Begin New Install"
                cell.lbl_syncStatus.isHidden = true
                
            } else {
                
                cell.installNumber = String(indexPath.row - 1)
                cell.syncStatus = "Sync !"
                cell.lbl_syncStatus.textColor = .red
                
            }
            
            break
        case completeInstallItem.index:
            
            cell.installNumber = String(indexPath.row)
            cell.syncStatus = "Sync ✓"
            cell.lbl_syncStatus.textColor = forrestGreenColor
            
            break
        case profileActionsItem.index:
            
            cell.lbl_installNumber.text = self.profileActions[ indexPath.row ]
            cell.lbl_syncStatus.isHidden = true
            
            break
        default:
            break
        }
    }

    
    //
    // Description:
    //   Tells table view if user should be allowed to have an "edit" option for a given index path
    //
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
