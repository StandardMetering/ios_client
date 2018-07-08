//
//  SignInViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit
import GoogleSignIn
import LocalAuthentication

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    @IBOutlet weak var lbl_applicationTitle: UILabel!
    @IBOutlet weak var btn_signIn: GIDSignInButton!
    @IBOutlet weak var lbl_activityText: UILabel!
    @IBOutlet weak var ai_loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lbl_copyrightInfo: UILabel!
    @IBOutlet weak var btn_proceed: UIButton!
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when view controller is loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopProcess()
        
        // Set static strings
        self.title = APPLICATION_TITLE
        self.lbl_applicationTitle.text = "Sign In"
        self.lbl_copyrightInfo.text = COPYRIGHT_STRING
        
        // Self handles sign in actions
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Check if saved user
        self.checkForUser()
    }

    
    //
    // Description:
    //   Checks if there is a currently signed in user.
    //
    func checkForUser() {
        if let user = UserModel.getSharedInstance() {
            stopProcess(forReason: "Local User: \(user.display_name)")
            self.btn_proceed.isHidden = false
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Segue
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //  Called when transitioning to next view controller
    //
    // Initialize next view controller here
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    //
    // Description:
    //   Called when another view controller unwinds to the sign in view controller
    //
    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) {
        GIDSignIn.sharedInstance().signOut()
        self.checkForUser()
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when the "Proceed Locally" button is pressed
    //
    @IBAction func proceedBtnPressed() {
        
        // Enusre there is a locally saved user
        guard let user = UserModel.getSharedInstance() else {
            print("User disconnect")
            return
        }
        
        // Get Local Authentication context
        let context = LAContext()
        
        // Ensure local authentication enabled
        var error: NSError? = nil
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            fatalError(error!.localizedDescription)
        }
        
        // Perform authentication
        context.localizedCancelTitle = "Cancel"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Sign In to Proceed") { success, error in
            
            if success {

                // Transition to sign in view
                DispatchQueue.main.async { [unowned self] in
                    user.onlineStatus = false
                    self.performSegue(withIdentifier: "segueToSplitView", sender: self)
                }
                
            } else {
                
                // Report failed authentication
                DispatchQueue.main.async { [unowned self] in
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    self.stopProcess(forReason: "Failed to authenticate.")
                    self.btn_proceed.isHidden = false
                }
            }
        }
    }

    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Utility Functions
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Utility function meant to update ui to indicate a process is running
    //
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
    
    //
    // Description:
    //   Informs user no task is taking place and an explination as to the result of the previously running task
    //
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
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - GID Sign In
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when a new google user has been signed in
    //
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Ensure there is no error
        guard error == nil else {
            
            // Print out error
            print("\(error.localizedDescription)")
            self.stopProcess(forReason: error.localizedDescription )
            self.btn_proceed.isHidden = false
            
            return
        }
        
        // Enuser a user was returned
        guard user != nil else {
            self.stopProcess(forReason: "Nil value found when expected user object." )
            return;
        }
        
        // Authenticate google user with server
        UserModel.signIn(newUser: user) { error, data  in
            
            // If there was an error authenticating...
            if let error = error {
                
                // Show error
                print( "Error: \(error.message)" )
                self.stopProcess(forReason: error.message)
                self.btn_proceed.isHidden = false
                
                // Sign google user out if this is not a valid internal user
                if error.code == StandardMeteringError.Code.tokenDoesNotMatchAnyUser {
                    GIDSignIn.sharedInstance().signOut()
                }
                
                return;
            }
            
            // Ensure data returned is user information
            guard let data = data as? UserInfo else {
                fatalError("Neither data nor error")
            }
            
            // Output user information
            print("New User: \(UserModel.getSharedInstance()!)")
            self.stopProcess(forReason: "\(data.display_name): Proceed local only or proceed online.")
            self.btn_proceed.isHidden = false
            
            // Segue to main menu
            self.performSegue(withIdentifier: "segueToSplitView", sender: self)
        }
    }
}
