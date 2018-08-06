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
    
    var completeInstalls = [InstallEntity]()
    var incompleteInstalls = [InstallEntity]()
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
    }
    
    
    //
    // Description:
    //   Called when new data is availible.
    //
    func present(installs: [InstallEntity]) {
        
        self.completeInstalls.removeAll()
        self.incompleteInstalls.removeAll()
        
        for install in installs {
            if install.complete {
                self.completeInstalls.append(install)
            } else {
                self.incompleteInstalls.append(install)
            }
        }
        
        self.masterViewController.tableView.reloadData()
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
            if let user = UserModel.getSharedInstance(),
                user.onlineStatus {
                return 1
            } else {
                return 0
            }
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
        
        // Branch based on section
        switch indexPath.section {
            
            // Sync Buttons section
            case syncActionItem.index:

                // Return sync buttons cell
                let cell = self.masterViewController.tableView.dequeueReusableCell(
                    withIdentifier: "SyncActionsCellModel",
                    for: indexPath
                ) as! SyncActionsCellModel
                
                cell.backgroundColor = .clear
                return cell
            
            // Incomplete Intstalls Section
            case incompleteInstallItem.index:
                
                // If first row
                if indexPath.row == 0 {
                    
                    // Get a basic cell
                    let cell = self.masterViewController.tableView.dequeueReusableCell(
                        withIdentifier: "BasicCell",
                        for: indexPath
                    )
                    
                    // Set the label
                    cell.textLabel!.text = "Create New Install"
                    return cell;
                    
                } else { // If install cell
                    
                    // Get install cell
                    let cell = self.masterViewController.tableView.dequeueReusableCell(
                        withIdentifier: "InstallCellViewModel",
                        for: indexPath
                    ) as! InstallCellViewModel
                    
                    // Populate cell
                    cell.install = self.incompleteInstalls[ indexPath.row - 1 ]
                    return cell;
                    
                }
            
            // Complete Installs section
            case completeInstallItem.index:
            
                // Get install cell
                let cell = self.masterViewController.tableView.dequeueReusableCell(
                    withIdentifier: "InstallCellViewModel",
                    for: indexPath
                ) as! InstallCellViewModel
                
                // Populate cell
                cell.install = self.completeInstalls[ indexPath.row ]
                return cell;
            
            case profileActionsItem.index:
            
                // Get a basic cell
                let cell = self.masterViewController.tableView.dequeueReusableCell(
                    withIdentifier: "BasicCell",
                    for: indexPath
                )
                
                // Set the label
                cell.textLabel!.text = profileActions[ indexPath.row ]
                return cell;
            
            
            default:
                
                // Populate with error cell
                let cell = self.masterViewController.tableView.dequeueReusableCell(
                    withIdentifier: "BasicCell",
                    for: indexPath
                )
                cell.textLabel!.text = "Unconfigured Cell"
                return cell
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
