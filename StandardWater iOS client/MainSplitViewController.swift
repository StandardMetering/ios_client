//
//  MainSplitViewController.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class MainSplitViewController: UISplitViewController {
    
    var userModel: UserModel?
    
    func signOutUser() {
        self.performSegue(withIdentifier: "unwindToSignInView", sender: self)
    }
    
}
