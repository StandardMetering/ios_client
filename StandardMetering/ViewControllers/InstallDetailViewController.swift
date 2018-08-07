//
//  InstallDetailViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/7/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class InstallDetailViewController: InstallViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_work: UIButton!
    @IBOutlet weak var btn_sync: UIButton!
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    /**
        Called when the view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        NotificationCenter.default.addObserver(
            forName: .installModelDidUpdate,
            object: nil,
            queue: .main,
            using: self.updateUI
        )
        
        updateUI()
    }
    
    
    /**
        Called as a segue is being performed to do any custom configuration.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If segueing to edit address
        if segue.identifier == "segueToEditInstallAddress" {
            
            // Get destination
            if let destVC = segue.destination as? InstallViewController {
                destVC.install = self.install
            }
        }
    }
    
    /**
        Called when visual elements need to be updated.
     */
    func updateUI(notification: Notification? = nil) {
        
        // Make sure there is an install to update to
        guard let install = self.install else {
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
                affirmLabel: "Okay"
            )
            return;
        }
        
        self.title = "Install #\(install.install_num ?? "NULL")"
        
        guard let currentUser = UserModel.getSharedInstance() else {
            displayActionSheet(
                withTitle: "Error",
                message: "Could not find signed in user",
                affirmLabel: "Okay"
            )
            return;
        }
        
        // Update sync button
        if currentUser.onlineStatus {
            self.btn_sync.isHidden = false
            if self.install.sync_status {
                self.btn_sync.setTitle(syncCompleteText, for: .normal)
                self.btn_sync.backgroundColor = .forrestGreen
            } else {
                self.btn_sync.setTitle(syncNeededText, for: .normal)
                self.btn_sync.backgroundColor = .red
            }
        } else {
            self.btn_sync.isHidden = true;
        }
        
        self.tableView.reloadData()
    }
    
    
    /**
        Called when performing an unwind segue back to this view controller.
     */
    @IBAction func unwindToInstallDetailView(segue: UIStoryboardSegue) {
        print("Unwind: \(self.install.able_to_complete)")
        self.updateUI()
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------

    
    /**
        Called when the "Work" button has been pressed by the user.
     */
    @IBAction func workButtonPressed() {
        performSegue(withIdentifier: "segueToEditInstallAddress", sender: self)
    }
    
    
    /**
     Called when the "Sync" button has been pressed by the user.
     */
    @IBAction func syncButtonPressed() {
        InstallModel.sync(install: self.install!)
        self.updateUI()
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Tableview Controller
    // -----------------------------------------------------------------------------------------------------------------
    
    
    /**
        Returns the number of sections in the table view
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /**
        Returns the number of rows in a given section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstallModel.installFieldDescriptions.count
    }
    
    
    /**
        Returns the cell to be displayed at a given index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "installItemDetailCell",
            for: indexPath
            ) as! InstallItemDetailCell

        cell.itemIdentifier = InstallModel.installFieldDescriptions[indexPath.row]
        let key = InstallModel.installFieldKeys[indexPath.row]
        let value = self.install.value(forKey: key)
        if value == nil {
            cell.itemDetail = "Not Set"
        } else if let boolVal = value as? Bool {
            cell.itemDetail = "\(boolVal.description)"
        } else {
            cell.itemDetail = "\(value!)"
        }
        return cell
    }
}
