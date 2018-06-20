//
//  SplitViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    
    var collapseDetailViewController: Bool = true
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Application lifecycle method called when view controller is loaded.
    //
    // UI Outlets not yet set up
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get app delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            // Set display mode button
            let navigationController = self.viewControllers[self.viewControllers.count-1] as! UINavigationController
            navigationController.topViewController!.navigationItem.leftBarButtonItem = self.displayModeButtonItem
            
            // Set app delegate as this view controller's delegate
            self.delegate = appDelegate
            
        } else {
            fatalError("Unresolved error: Unable to load application delegate.")
        }
    }
    
    
    //
    // Description:
    //   Determines if the master view controller should be collapsed.
    //
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        
        return self.collapseDetailViewController
    }
}
