//
//  CreateNewInstallViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/13/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class CreateNewInstallViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tf_installNumber: UITextField!
    @IBOutlet weak var tf_street: UITextField!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var pv_state: UIPickerView!
    @IBOutlet weak var tf_zip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pv_state.dataSource = self
        self.pv_state.delegate = self
        
        self.tf_street.delegate = self
        self.tf_city.delegate = self
        self.tf_zip.delegate = self
        
        self.title = "Create New Install"
    }
    
    @IBAction func btnCreatePressed() {
        
    }
    
    // Picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usStates.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usStates[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
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
