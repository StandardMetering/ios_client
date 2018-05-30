//
//  MainMenuViewController.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/16/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class MainMenuViewController: UITableViewController, UISplitViewControllerDelegate {
    
    private var collapseDetailViewController = true
    private var detailDisplaySelected: DetailDisplay?
    private var selectedInstall: InstallModel?
    
    var userModel: UserModel!
    
    // Table view contants
    let sectionTitles = ["Installs", "Account Acctions"]
    let accountActions = ["View Profile", "Sign Out"]
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // ----------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        // Nav Bar
        self.title = "Standard Meetering"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        fetchAllInstalls()
        
        // Get user model
        if let splitVC = self.splitViewController as? MainSplitViewController {
            if let userModel = splitVC.userModel {
                self.userModel = userModel
            }
        }
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Installs")
        refreshControl?.addTarget(self, action: #selector(didRecieveRefreshSignal), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    // Stub
    @objc func addTapped() {
        self.detailDisplaySelected = .beginNewInstall
        self.selectedInstall = InstallModel()
        
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func signOutOptionTapped() {
        GIDSignIn.sharedInstance().signOut()
        let actionSheet = UIAlertController(
            title: "Sign Out?",
            message: "Are you sure you want to sign out?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(
            title: "Sign Out",
            style: .destructive,
            handler: { uiAlertAction in
                if let splitViewController = self.splitViewController as? MainSplitViewController {
                   splitViewController.signOutUser()
                }
        }))
        
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        self.present(actionSheet, animated: true)
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool
    {
        return self.collapseDetailViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.collapseDetailViewController = false
        
        if segue.identifier == "showDetail" {
            if let dest = segue.destination as? DetailViewContainer {
                dest.detailToDisplay = self.detailDisplaySelected
                dest.installModel = self.selectedInstall
            }
        }
    }
    
    @objc func didRecieveRefreshSignal() {
        print("Refresh")
        
        fetchAllInstalls()
        
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func fetchAllInstalls() {
        return
    }
    
    // ----------------------------------------------------------------------------------------------------------------
    // MARK: - Table View Controller
    // ----------------------------------------------------------------------------------------------------------------
    
    // Num sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    // Section titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.userModel.displayName + "'s " + self.sectionTitles[ section ]
    }
    
    // Num rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 10 + 1;
        case 1:
            return accountActions.count
        default:
            return 0;
        }
    }
    
    // Cell for index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Switch on different sections
        switch indexPath.section {
            
        // Installs Section
        case 0:
            
            // Add Install Row
            if( indexPath.row == 0 ) {
                if let label = cell.textLabel {
                    label.text = "Add New Install"
                }
                break;
            }
            
            // Recent Intall Rows
            cell.accessoryType = .disclosureIndicator
            if let label = cell.textLabel {
                label.text = "Install \(indexPath.row)"
            }
            break
            
        // Account Section
        case 1:
            
            // Display different account actions
            if let label = cell.textLabel {
                label.text = accountActions[indexPath.row]
                
                if indexPath.row == 1 {
                    label.text = accountActions[indexPath.row] + " " + userModel.displayName
                }
            }
            
            break
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                self.detailDisplaySelected = .beginNewInstall
                self.selectedInstall = InstallModel()
            } else {
                self.detailDisplaySelected = .completeInstall
                self.selectedInstall = InstallModel(installNum: indexPath.row - 1)
            }
            
            self.performSegue(withIdentifier: "showDetail", sender: self)
            
            break
        case 1:
            if indexPath.row == 1 {
                self.signOutOptionTapped()
            }
            break
        default:
            break
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
