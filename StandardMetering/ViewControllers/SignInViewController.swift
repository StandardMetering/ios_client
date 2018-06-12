//
//  SignInViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var lbl_applicationTitle: UILabel!
    @IBOutlet weak var btn_signIn: GIDSignInButton!
    @IBOutlet weak var lbl_activityText: UILabel!
    @IBOutlet weak var ai_loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lbl_copyrightInfo: UILabel!
    @IBOutlet weak var btn_proceed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopProcess()
        
        self.title = APPLICATION_TITLE
        self.lbl_applicationTitle.text = "Sign In"
        self.lbl_copyrightInfo.text = COPYRIGHT_STRING
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if let user = UserModel.getSharedInstance() {
            stopProcess(forReason: "Local User: \(user.display_name)")
            self.btn_proceed.isHidden = false
        }
    }

    func startProcess(withName processName: String? = nil) {
        
        self.ai_loadingIndicator.startAnimating()
        self.ai_loadingIndicator.isHidden = false
        
        if let name = processName {
            self.lbl_activityText.text = name
            self.lbl_activityText.isHidden = false
        } else {
            self.lbl_activityText.isHidden = true
        }
        
    }
    
    func stopProcess(forReason haltReason: String? = nil) {
        
        self.ai_loadingIndicator.isHidden = true
        self.ai_loadingIndicator.stopAnimating()
        self.btn_proceed.isHidden = true
        
        if let reason = haltReason {
            self.lbl_activityText.text = reason
            self.lbl_activityText.isHidden = false
        } else {
            self.lbl_activityText.isHidden = true
        }
    }
    
    @IBAction func proceedBtnPressed() {
        
        guard let user = UserModel.getSharedInstance() else {
            print("User disconnect")
            return
        }
        
        user.onlineStatus = false
        performSegue(withIdentifier: "segueToSplitView", sender: self)
    }
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // Mark: - GIDSignIn
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            
            // Print out error
            print("\(error.localizedDescription)")
            
            self.stopProcess(forReason: error.localizedDescription )
            
            return
        }
        
        guard user != nil else {
            self.stopProcess(forReason: "Nil value found when expected user object." )
            return;
        }
        
        UserModel.signIn(newUser: user) { error in
            
            if let error = error {
                print( "Error: \(error.localizedDescription)" )
                return;
            }
            
            print("New User: \(UserModel.getSharedInstance()!)")
            self.stopProcess(forReason: "Proceed locally or proceed online.")
            self.btn_proceed.isHidden = false
            
            guard let user = UserModel.getSharedInstance() else {
                return
            }
            
            // Alert view to allow user to be added
            let alert = UIAlertController(title: "Proceed",
                                          message: "Proceed as online user \"\(user.display_name)\"",
                preferredStyle: .alert)
            
            // Option in alert view to save
            let proceedAction = UIAlertAction(title: "Proceed", style: .default) { [unowned self] action in
                user.onlineStatus = true
                self.performSegue(withIdentifier: "segueToSplitView", sender: self)
            }
            
            // Option in alert view to save
            let signOutAction = UIAlertAction(title: "Sign this user out", style: .destructive) { action in
                GIDSignIn.sharedInstance().signOut()
            }
            
            // Option in allert view to cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
            // Add actions to alert view
            alert.addAction(proceedAction)
            alert.addAction(signOutAction)
            alert.addAction(cancelAction)
            
            // Present alert view
            self.present(alert, animated: true)
        }
            
        }
        
    
}
