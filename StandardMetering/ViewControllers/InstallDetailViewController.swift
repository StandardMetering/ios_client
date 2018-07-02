//
//  InstallDetailViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/1/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class InstallDetailViewController: EditInstallViewController {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var tf_installNum: UITextField!
    @IBOutlet weak var tf_street: UITextField!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_state: UITextField!
    @IBOutlet weak var tf_zip: UITextField!
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_sync: UIButton!
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when view controller is loaded into memory.
    //
    // View outlets not yet set up.
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //
    // Description:
    //   Called when the view is loaded and about to appear.
    //
    // View outlets are expected to be set up at this point.
    //
    override func viewWillAppear(_ animated: Bool) {
        
        guard let _ = self.install else {
            
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
                affirmLabel: "Okay"
            )
            
            return;
        }
        
        updateUI()
    }
    
    
    //
    // Description:
    //   Called whenever any changes have been made that may affect the UI.
    //
    override func updateUI() {
        super.updateUI()
        
        // Make sure there is an install to update to
        guard let _ = self.install else {
            
            self.btn_edit.isEnabled = false
            
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
                affirmLabel: "Okay"
            )
            
            return;
        }
        
        guard let currentUser = UserModel.getSharedInstance() else {
            
            self.btn_edit.isEnabled = false
            
            displayActionSheet(
                withTitle: "Error",
                message: "Could not find signed in user",
                affirmLabel: "Okay"
            )
            
            return;
        }
        
        // Set title
        self.title = "Install #\(install.install_num!)"
        
        // Set text field enabled properties
        self.tf_installNum.isEnabled = self.isEditingInstall
        self.tf_street.isEnabled = self.isEditingInstall
        self.tf_city.isEnabled = self.isEditingInstall
        self.tf_state.isEnabled = self.isEditingInstall
        self.tf_zip.isEnabled = self.isEditingInstall
        
        // Set text field text
        self.tf_installNum.text = self.install.install_num
        self.tf_street.text = self.install.address_street!
        self.tf_city.text = self.install.address_city!
        self.tf_state.text = self.install.address_state!
        self.tf_zip.text = self.install.address_zip!
        
        // Update sync button
        if currentUser.onlineStatus {
            self.btn_sync.isHidden = self.isEditingInstall
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
        
        // Update edit button
        self.btn_edit.isEnabled = true
        self.btn_edit.isHidden = self.isEditingInstall
    }
    
    
    //
    // Description:
    //   Called when the user has edited values and wants to save them.
    //
    override func userIndicatesSaveIntention() {
        
        self.updateInstallEntityWithUIValues()
        
        if !InstallModel.saveContext() {
            displayActionSheet(
                forView: self.btn_saveAndContinue,
                withTitle: "Error saving changes.",
                message: "There was a problem saving your changes",
                affirmLabel: "Okay"
            )
        }
        
    }
    
    //
    // Description:
    //   Called when the user wants to coninue to the next step of the install process.
    //
    override func userIndicatesContinueIntention() {
        
        displayActionSheet(
            forView: self.btn_edit,
            withTitle: "Continue",
            message: "Continue to next step of install",
            affirmLabel: "Okay"
        )
        
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when the user presses the "Edit" button.
    //
    @IBAction func editButtonPressed(_ sender: UIButton) {
        self.isEditingInstall = true;
        self.updateUI()
    }
    
    
    //
    // Description:
    //   Called when the user presses the "Sync" button.
    //
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        displayActionSheet(
            forView: sender,
            withTitle: "Sync",
            message: "Sync button pressed.",
            affirmLabel: "Okay"
        )
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Utility functions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Helper function to put ui values into install entity.
    //
    private func updateInstallEntityWithUIValues() {
        
        // Make sure there is an install to update to
        guard let _ = self.install else {
            
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
                affirmLabel: "Okay"
            )
            
            return;
        }
        
        self.install.install_num = self.tf_installNum.text ?? ""
        self.install.address_street = self.tf_street.text ?? ""
        self.install.address_city = self.tf_city.text ?? ""
        self.install.address_state = self.tf_state.text ?? ""
        self.install.address_zip = self.tf_zip.text ?? ""
        
    }
    
}
