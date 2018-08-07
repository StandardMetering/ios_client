//
//  EditPreInstallViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 8/6/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class EditPreInstallViewController: EditInstallViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var lbl_image: UILabel!
    @IBOutlet weak var lbl_valvePos: UILabel!
    @IBOutlet weak var lbl_notes: UILabel!
    
    @IBOutlet weak var switch_ableToComplete: UISwitch!
    @IBOutlet weak var btn_image: UIButton!
    @IBOutlet weak var tf_valvePos: UITextField!
    @IBOutlet weak var ta_notes: UITextView!
    var picker_valvePos = UIPickerView()
    
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker_valvePos.dataSource = self
        self.picker_valvePos.delegate = self
        self.tf_valvePos.inputView = picker_valvePos
        
        self.updateUI()
    }
    
    
    override func updateUI() {
        super.updateUI()
        
        // Make sure there is an install to update to
        guard let install = self.install else {
            displayActionSheet(
                withTitle: "Error",
                message: "Install to display not set.",
                affirmLabel: "Okay"
            )
            return;
        }
        
        // Get current user
        guard let _ = UserModel.getSharedInstance() else {
            displayActionSheet(
                withTitle: "Error",
                message: "Could not find signed in user",
                affirmLabel: "Okay"
            )
            return;
        }
        
        // Set title
        self.title = "Install #\(install.install_num ?? "NULL")"
        
        self.switch_ableToComplete.isOn = install.able_to_complete
        
        self.btn_image.setTitle(
            (install.pre_image != nil ? "Photo" : "Photo Not Set"),
            for: .normal
        )
        
        // If able to complete == YES
        if install.able_to_complete {
            
            self.lbl_image.text = "Pre-install Image:"
            
            self.lbl_notes.isHidden = true
            self.ta_notes.isHidden = true
            
            self.lbl_valvePos.isHidden = false
            self.tf_valvePos.isHidden = false
            self.tf_valvePos.text = self.install.pre_valve_pos ? "On" : "Off"
            
        }
        // If able to complete == NO
        else {
            
            self.lbl_image.text = "Image of problem:"
            
            self.lbl_notes.isHidden = false
            self.ta_notes.isHidden = false
            self.ta_notes.text = self.install.pre_notes
            
            self.lbl_valvePos.isHidden = true
            self.tf_valvePos.isHidden = true
            
        }
        
        
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------
    
    @IBAction func ableToCompleteValueChanged() {
        self.install.able_to_complete = self.switch_ableToComplete.isOn
        self.updateUI()
    }
    
    @IBAction func imageButtonPressed() {
        
        // Init option menu
        let optionMenu = UIAlertController(
            title: "Photo",
            message: "How would you like to attach a photo",
            preferredStyle: .actionSheet
        )
        
        if let prevImage = self.install.pre_image {
            
            let viewPhotoAction = UIAlertAction(title: "View Photo", style: .default) { alert in
                print("View photo: \(prevImage)")
            }
            optionMenu.addAction(viewPhotoAction)
            
        }
        
        // Take photo action
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { alert in
                self.imagePicker = UIImagePickerController()
                self.imagePicker!.delegate = self
                self.imagePicker!.sourceType = .camera
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
            optionMenu.addAction(takePhotoAction)
        }
        
        // Choose photo action
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { alert in
            self.imagePicker = UIImagePickerController(rootViewController: self)
            self.imagePicker!.delegate = self
            self.imagePicker!.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        optionMenu.addAction(choosePhotoAction)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        
        // Present option menu
        optionMenu.popoverPresentationController?.sourceView = self.btn_image
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Edit Install
    // -----------------------------------------------------------------------------------------------------------------
    
    
    override func userIndicatesSaveIntention() {
        self.updateInstallEntityWithUIValues()
        print("Pre save: \(self.install.able_to_complete)")
        super.userIndicatesSaveIntention()
    }
    
    
    override func userIndicatesContinueIntention() {
        super.userIndicatesContinueIntention()
        
        displayActionSheet(
            forView: self.btn_saveAndContinue,
            withTitle: "Continue",
            message: "Continue to next step of install",
            affirmLabel: "Okay"
        )
    }
    
    
    override func userIndicatesExitIntention() {
        super.userIndicatesExitIntention()
        
        performSegue(withIdentifier: "unwindToInstallDetailView", sender: self)
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Picker View
    // -----------------------------------------------------------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "On" : "Off";
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tf_valvePos.text = row == 0 ? "On" : "Off"
        self.install.pre_valve_pos = row == 0
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Utility Functions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker!.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImagePNGRepresentation(image)
            self.install.pre_image = imageData?.base64EncodedString()
        } else {
            displayActionSheet(
                withTitle: "Error",
                message: "Error retrieving image.",
                affirmLabel: "Okay"
            )
        }
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Utility Functions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    private func updateInstallEntityWithUIValues() {
        if !self.install.able_to_complete {
            self.install.pre_notes = self.ta_notes.text
        }
    }
    
}
