//
//  BeginNewInstallViewController.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import UIKit

class BeginNewInstallViewController: UIViewController, UITextFieldDelegate {
    
    var userModel: UserModel!
    var installModel: InstallModel?
    
    // UI Outlets
    @IBOutlet weak var tf_installNum: UITextField!
    @IBOutlet weak var tf_street: UITextField!
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var tf_state: UITextField!
    @IBOutlet weak var tf_zip: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = "New Install"
        
        // Text Fields
        self.tf_installNum.delegate = self
        self.tf_street.delegate = self
        self.tf_city.delegate = self
        self.tf_state.delegate = self
        self.tf_zip.delegate = self
        
        let newBackButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        navigationController?.popViewController(animated: false)
    }
    
    // UI Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == self.tf_installNum {
            tf_street.becomeFirstResponder()
        } else if textField == self.tf_street {
            tf_city.becomeFirstResponder()
        } else if textField == tf_city {
            tf_zip.becomeFirstResponder()
        } else if textField == tf_zip {
            submitPressed()
        }
        
        return true
    }
    
    // Actions
    @IBAction func submitPressed() {
        print("submit")
        
        let add = InstallAddress()
        add.street = self.tf_street.text
        add.city = self.tf_city.text
        add.state = self.tf_state.text
        add.zip = self.tf_zip.text
        
        InstallModel.createNewInstall(user: userModel, installNum: Int(self.tf_installNum.text!)!, address: add)
    }
    
    
}
