//
//  InstallDetailViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/1/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class InstallDetailViewController: UIViewController {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    var install: InstallEntity! = nil
    
    @IBOutlet weak var tf_installNum: UITextField!
    @IBOutlet weak var tf_street: UITextField!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_state: UITextField!
    @IBOutlet weak var tf_zip: UITextField!
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_sync: UIButton!
    
    private var isEditingInstall: Bool = false
    
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
    func updateUI() {
    
        // Make sure there is an install to update to
        guard let _ = self.install else {
            
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
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
        
        // Set text
        self.tf_installNum.text = self.install.install_num
        self.tf_street.text = self.install.address_street!
        self.tf_city.text = self.install.address_city!
        self.tf_state.text = self.install.address_state!
        self.tf_zip.text = self.install.address_zip!
        
        // Update buttons
        if self.install.sync_status {
            self.btn_sync.setTitle(syncCompleteText, for: .normal)
            self.btn_sync.backgroundColor = .forrestGreen
        } else {
            self.btn_sync.setTitle(syncNeededText, for: .normal)
            self.btn_sync.backgroundColor = .red
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when the user presses the "Edit" button.
    //
    @IBAction func editButtonPressed(_ sender: UIButton) {
        displayActionSheet(
            forView: sender,
            withTitle: "Edit",
            message: "Edit button pressed.",
            affirmLabel: "Okay"
        )
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
    
}
