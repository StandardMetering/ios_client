//
//  SplitViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let navigationController = self.viewControllers[self.viewControllers.count-1] as! UINavigationController
            navigationController.topViewController!.navigationItem.leftBarButtonItem = self.displayModeButtonItem
            self.delegate = appDelegate
            
            let masterNavigationController = self.viewControllers[0] as! UINavigationController
            let controller = masterNavigationController.topViewController as! MasterViewController
            controller.managedObjectContext = appDelegate.persistentContainer.viewContext
            
        } else {
            fatalError("Unresolved error: Unable to load application delegate.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
