//
//  BeginNewInstallViewController.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import UIKit

class BeginNewInstallViewController: UIViewController {
    
    var installModel: InstallModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBackButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print( "Model number: \(self.installModel?.description ?? "Nil")")
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        navigationController?.popViewController(animated: false)
    }
}
