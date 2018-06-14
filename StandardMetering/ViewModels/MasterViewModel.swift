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

class TableSectionItem {
    var title: String
    var index: Int
    
    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
}

let syncActionItem = TableSectionItem(title: "", index: 0)
let incompleteInstallItem = TableSectionItem(title: "Incomplete Installs", index: 1)
let completeInstallItem = TableSectionItem(title: "Complete Installs", index: 2)
let profileActionsItem = TableSectionItem(title: "Profile Actions", index: 3)

let tableSectionTitles = [
    syncActionItem,
    incompleteInstallItem,
    completeInstallItem,
    profileActionsItem
]


class MasterViewModel: NSObject, UITableViewDataSource {
    
    private let masterViewController: MasterViewController
    
    private var completeInstalls = [InstallEntity?]()
    private var incompleteInstalls = [InstallEntity?]()
    private let profileActions = [
        "Sign Out"
    ]
    
    init(master masterViewController: MasterViewController) {
        self.masterViewController = masterViewController
        
        incompleteInstalls.append(nil)
        incompleteInstalls.append(nil)
        incompleteInstalls.append(nil)
        
        completeInstalls.append(nil)
        completeInstalls.append(nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionTitles[ section ].title
    }
    
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case syncActionItem.index:
            let cell = self.masterViewController.tableView.dequeueReusableCell(withIdentifier: "SyncActionsCellModel") as! SyncActionsCellModel
        
            cell.backgroundColor = .clear
            
            return cell
        default:
            let cell = self.masterViewController.tableView.dequeueReusableCell(withIdentifier: "InstallCellViewModel") as! InstallCellViewModel
            
            initCell(cell)
            configureCell(cell, atIndexPath: indexPath)
            
            return cell
        }
        
        
    }
    
    func initCell(_ cell: InstallCellViewModel ) {
//
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.lbl_installNumber.isHidden = false
        cell.lbl_installNumber.textColor = .black
        
        cell.lbl_syncStatus.isHidden = false
        cell.lbl_syncStatus.textColor = .black
    }
    
    func configureCell(_ cell: InstallCellViewModel, atIndexPath indexPath: IndexPath) {
        
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

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
