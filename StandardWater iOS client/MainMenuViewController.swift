//
//  MainMenuViewController.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/16/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UITableViewController {
    
    let sectionTitles = ["Installs", "Account Acctions"]
    let accountActions = ["View Profile", "Sign Out"]
    
    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        print("add tapped")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[ section ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 10;
        case 1:
            return accountActions.count
        default:
            return 0;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.accessoryType = .disclosureIndicator
            if let label = cell.textLabel {
                label.text = "Install \(indexPath.row + 1)"
            }
            break
        case 1:
            if let label = cell.textLabel {
                label.text = accountActions[indexPath.row]
            }
            break
        default:
            break
        }
        
        return cell
    }
    
    
}
