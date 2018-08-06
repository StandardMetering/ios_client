//
//  InstallDetailViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/1/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class EditInstallAddressViewController: EditInstallViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var tf_installNum: UITextField!
    @IBOutlet weak var tf_street: UITextField!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_state: UITextField!
    @IBOutlet weak var tf_zip: UITextField!
    
    let pv_state = UIPickerView()
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when view controller is loaded into memory.
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pv_state.dataSource = self
        self.pv_state.delegate = self
        self.tf_state.inputView = self.pv_state
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToEditPreInstall" {
            if let destVC = segue.destination as? EditPreInstallViewController {
                destVC.install = self.install
            }
        }
        
    }
    
    
    /**
        Called whenever any changes have been made that may affect the UI.
     */
    override func updateUI() {
        super.updateUI()
        
        // Make sure there is an install to update to
        guard let _ = self.install else {
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
                affirmLabel: "Okay"
            )
            return;
        }
        
        guard let _ = UserModel.getSharedInstance() else {
            displayActionSheet(
                withTitle: "Error",
                message: "Could not find signed in user",
                affirmLabel: "Okay"
            )
            return;
        }
        
        // Set title
        self.title = "Edit Address"
        
        // Set text field enabled properties
        self.tf_installNum.isEnabled = true
        self.tf_street.isEnabled = true
        self.tf_city.isEnabled = true
        self.tf_state.isEnabled = true
        self.tf_zip.isEnabled = true
        
        // Set text field text
        self.tf_installNum.text = self.install.install_num
        self.tf_street.text = self.install.address_street!
        self.tf_city.text = self.install.address_city!
        self.tf_state.text = self.install.address_state!
        self.tf_zip.text = self.install.address_zip!
    }
    
    
    
    /**
        Called when the user wants to save the install.
     */
    override func userIndicatesSaveIntention() {
        super.userIndicatesSaveIntention()
        
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
    
    
    /**
        Called when the user wants to coninue to the next step of the install process.
     */
    override func userIndicatesContinueIntention() {
        super.userIndicatesSaveIntention()
        
        performSegue(withIdentifier: "segueToEditPreInstall", sender: self)
    }
    
    
    /**
        Called when the user wants to exit the edit install process.
     */
    override func userIndicatesExitIntention() {
        super.userIndicatesSaveIntention()
        
        performSegue(withIdentifier: "unwindToInstallDetailView", sender: self)
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Picker View
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Return the number of columns in the picker view
    //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //
    // Description:
    //   Determines the number of rows in a column
    //
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usStates.count
    }
    
    
    //
    // Description:
    //   Gets the label text for a specific picker view row
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usStates[row]
    }
    
    
    //
    // Description:
    //   Called when a user has selected a specific picker view row
    //
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tf_state.text = usStates[row].split(separator: "-")[1].trimmingCharacters(in: .whitespaces)
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Utility functions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    /**
        Helper function to put ui values into install entity.
    */
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
