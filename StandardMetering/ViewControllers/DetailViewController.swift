//
//  DetailViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }
}

