//
//  EditInstallViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/1/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class EditInstallViewController: UIViewController {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    var install: InstallEntity! = nil
    
    @IBOutlet weak var btn_saveAndContinue: UIButton!
    @IBOutlet weak var btn_saveAndExit: UIButton!
    @IBOutlet weak var btn_cancelAndExit: UIButton!
    
    var isEditingInstall: Bool = false
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when the view controller is loaded into memory.
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //
    // Description:
    //   Called whenever any changes have been made that may affect the UI.
    //
    func updateUI() {
        
        self.btn_saveAndContinue.isHidden = !self.isEditingInstall
        self.btn_saveAndExit.isHidden = !self.isEditingInstall
        self.btn_cancelAndExit.isHidden = !self.isEditingInstall
        
    }
    
    func userIndicatesSaveIntention() {
        
    }
    
    func userIndicatesContinueIntention() {
        
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------
    
    //
    // Description:
    //   Called when the save and continue button is pressed.
    //
    @IBAction func btnSaveAndContinuePressed() {

        self.userIndicatesSaveIntention()
        self.isEditingInstall = false
        self.updateUI()
        self.userIndicatesContinueIntention()
        
    }
    
    
    //
    // Description:
    //   Called when the save and exit button is pressed.
    //
    @IBAction func btnSaveAndExitPressed() {
    
        self.userIndicatesSaveIntention()
        self.isEditingInstall = false
        self.updateUI()
        
    }
    
    
    //
    // Description:
    //   Called when the cancel and exit button is pressed.
    //
    @IBAction func btnCancelAndExitPressed() {
        
        self.isEditingInstall = false
        self.updateUI()
        
    }
    
    
    
}
