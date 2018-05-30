import Foundation
import UIKit
import GoogleSignIn

// Constants
let TitleText = "Standard Meetering"

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var lbl_loadingLabel: UILabel!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    var userModel: UserModel?
    
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
    
    @IBAction func unwindToSignInView(segue:UIStoryboardSegue) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut()
        self.sign(nil, didDisconnectWith: nil, withError: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInToMainMenu" {
            if let dest = segue.destination as? MainSplitViewController {
                dest.userModel = self.userModel
            }
        }
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
            
            // Update view
            self.signInButton.isEnabled = false
            self.lbl_loadingLabel.isHidden = false
            self.lbl_loadingLabel.text = "Authenticating \(user.profile!.name!)."
            self.loadingWheel.isHidden = false
            self.loadingWheel.startAnimating()
            
            UserModel(user).authenticateAsStandardWaterUser(onComplete: self.handleSW_Authentication)
        }
    }
    
    func handleSW_Authentication( isValidSWUser: Bool, user: UserModel? ) {
        
        if( isValidSWUser ) {
            
            print("ID: \(user!.googleID)")
            
            // Update view
            self.signInButton.isEnabled = false
            self.lbl_loadingLabel.isHidden = false
            self.lbl_loadingLabel.text = "\(user!.displayName) authenticated."
            self.loadingWheel.isHidden = true
            self.loadingWheel.stopAnimating()
            
            self.userModel = user;
            performSegue(withIdentifier: "signInToMainMenu", sender: self)
            
        } else {
            
            // Update view
            self.signInButton.isEnabled = true
            self.lbl_loadingLabel.isHidden = false
            self.lbl_loadingLabel.text = "Not a valid Standard Water user."
            self.loadingWheel.isHidden = true
            self.loadingWheel.stopAnimating()
            
            GIDSignIn.sharedInstance().signOut()
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
