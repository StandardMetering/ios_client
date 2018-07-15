//
//  EditInstallViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/1/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class EditInstallViewController: InstallViewController {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var btn_saveAndContinue: UIButton!
    @IBOutlet weak var btn_saveAndExit: UIButton!
    @IBOutlet weak var btn_cancelAndExit: UIButton!
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /**
        Called whenever any changes have been made that may affect the UI.
     */
    func updateUI() {
    }
    
    
    /**
        Called whenever the user has expressed they wish for a save to take place.
     */
    func userIndicatesSaveIntention() {
        self.install.sync_status = false
    }
    
    
    /**
        Called when user has indicated they wish to continue to the next stage of editing.
     */
    func userIndicatesContinueIntention() {
    }
    
    
    /**
        Called when user has indicated they wish to exit the editing process.
     */
    func userIndicatesExitIntention() {
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    
    /**
        Called when user pressed the "Save and Continue" button
     */
    @IBAction func btnSaveAndContinuePressed() {

        self.userIndicatesSaveIntention()
        self.updateUI()
        self.userIndicatesContinueIntention()
        
    }
    
    
    /**
        Called when the save and exit button is pressed.
     */
    @IBAction func btnSaveAndExitPressed() {
    
        self.userIndicatesSaveIntention()
        self.updateUI()
        self.userIndicatesExitIntention()
    }
    
    
    /**
        Called when the cancel and exit button is pressed.
     */
    @IBAction func btnCancelAndExitPressed() {
        
        self.updateUI()
        self.userIndicatesExitIntention()
    }
    
    
    
}
