//
//  DisplayImageViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 8/7/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var lbl_imageName: UILabel!
    @IBOutlet weak var btn_decline: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resolutionSlider: UISlider!
    
    var imageToDisplay: UIImage? = nil{
        didSet {
            self.updateImageInView()
        }
    }
    var currentImageData: Data? = nil {
        didSet {
            if let data = self.currentImageData {
                imageView.image = UIImage(data: data)
                if let label = self.lbl_imageName {
                    label.text = "Image Size: \(data.count)"
                }
            }
        }
    }
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        updateImageInView()
    }
    
    func updateImageInView() {
        
        // Update image in view
        if let image = self.imageToDisplay {
            if let imageView = self.imageView {
                imageView.image = image
            }
        }
        
        // Update slider
        if let slider = self.resolutionSlider {
            slider.setValue(1, animated: false)
        }
    }
    
    
    func adjustImage(toQuality quality: Float) {
        
        // Update image in view
        if let image = self.imageToDisplay {
            self.currentImageData = UIImageJPEGRepresentation(image, CGFloat(quality))
        }
    }
    
    
    @IBAction func resolutionSliderValueChanged(_ sender: Any? = nil) {
        self.adjustImage(toQuality: self.resolutionSlider.value)
    }

    
    @IBAction func declineImagePressed() {
        
        // Init option menu
        let optionMenu = UIAlertController(
            title: "Photo",
            message: "How would you like to attach a photo",
            preferredStyle: .actionSheet
        )
        
        // Take photo action
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { alert in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            optionMenu.addAction(takePhotoAction)
        }
        
        // Choose photo action
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { alert in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        optionMenu.addAction(choosePhotoAction)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        
        // Present option menu
        optionMenu.popoverPresentationController?.sourceView = self.btn_decline
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Image Picker Controller
    // -----------------------------------------------------------------------------------------------------------------
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Reset to normal view
        self.resolutionSlider.setValue(1.0, animated: false)
       
        // Display image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageToDisplay = image
        } else {
            displayActionSheet(
                withTitle: "Error",
                message: "Error retrieving image.",
                affirmLabel: "Okay"
            )
        }
    }
}
