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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_applicationTitle.text = APPLICATION_TITLE
        self.lbl_copyrightInfo.text = COPYRIGHT_STRING
        
        self.stopProcess()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
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
        
        if let reason = haltReason {
            self.lbl_activityText.text = reason
            self.lbl_activityText.isHidden = false
        } else {
            self.lbl_activityText.isHidden = true
        }
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
        
        self.stopProcess(forReason: "User identified as: \(user.profile.name!)")
    }
    
}
