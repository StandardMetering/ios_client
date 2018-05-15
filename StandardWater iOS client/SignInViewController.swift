import Foundation
import UIKit
import GoogleSignIn

// Constants
let TitleText = "Standard Water"

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var lbl_title: UILabel!
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // ----------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_title.text = TitleText
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------------------------------------------------------------------
    
    @IBAction func btn_pressed() {
        
    }
    
}
