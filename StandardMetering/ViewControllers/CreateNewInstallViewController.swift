//
//  CreateNewInstallViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/13/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class CreateNewInstallViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    @IBOutlet weak var tf_installNumber: UITextField!
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
    //   Called when view is loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pv_state.dataSource = self
        self.pv_state.delegate = self
        
        self.tf_street.delegate = self
        self.tf_city.delegate = self
        self.tf_zip.delegate = self
        
        self.tf_state.inputView = self.pv_state
        
        self.title = "Create New Install"
    }
    
    
    //
    // Description:
    //   Called when the user presses the "Create" button
    //
    @IBAction func btnCreatePressed() {
        
        guard let installNum = self.tf_installNumber.text, installNum.count > 0 else {
            print("Please proved a valid install number")
            return
        }
        
        guard let street = self.tf_street.text, street.count > 0 else {
            print("Please proved a valid street")
            return
        }
        
        guard let city = self.tf_city.text, city.count > 0 else {
            print("Please proved a valid city")
            return
        }
        
        guard let state = self.tf_state.text, state.count > 0 else {
            print("Please proved a valid state")
            return
        }
        
        guard let zip = self.tf_zip.text, zip.count == 5 else {
            print("Please proved a valid zip code")
            return
        }
        
        let address = Address(
            street: street,
            city: city,
            state: state,
            zip: zip
        )
        
        InstallModel.createNewInstall(withNum: installNum, address: address)
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Picker View Controll
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
    // MARK: - Text Field Delegate
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Indicateds if the given text field should return
    //
    // Used to "tab" to next text field
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return false
    }
}
