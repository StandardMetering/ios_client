import Foundation
import UIKit
import GoogleSignIn

// Constants
let TitleText = "Standard Water"

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var lbl_loadingLabel: UILabel!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // ----------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_title.text = TitleText
        self.lbl_loadingLabel.isHidden = true
        self.loadingWheel.isHidden = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - GID Sign in Delegate
    // ----------------------------------------------------------------------------------------------------------------
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Check for error
        if let error = error {
            
            // Print out error
            print("\(error.localizedDescription)")
            
        } else {
            
            // Get data from sign in
            let _ = user.authentication.idToken
            let fullName = user.profile.name
            
            // Update view
            self.signInButton.isEnabled = false
            self.lbl_loadingLabel.isHidden = false
            self.lbl_loadingLabel.text = "Authenticating \(fullName!)."
            self.loadingWheel.isHidden = false
            self.loadingWheel.startAnimating()
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        // Log
        print("Google User Disconnected")
        
        // Update View
        self.signInButton.isEnabled = true
        self.lbl_loadingLabel.isHidden = true
        self.loadingWheel.isHidden = true
        self.loadingWheel.stopAnimating()
    }
}
