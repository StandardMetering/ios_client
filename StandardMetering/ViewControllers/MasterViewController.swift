//
//  MasterViewController.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Member Variables
    // -----------------------------------------------------------------------------------------------------------------
    
    
    var viewModel: MasterViewModel! = nil
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var splitVC: SplitViewController! = nil

    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Application Lifecycle
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Initialize with table view style.
    //
    // Least used
    //
    override init(style: UITableViewStyle) {
        
        super.init(style: style)
        
        // Initialize table view model
        self.viewModel = MasterViewModel(master: self)

        
        // Initialize persistant store managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to load application delegate")
        }
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    
    //
    // Description:
    //   Initialize with a decoder.
    //
    // Most used
    //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize table view model
        self.viewModel = MasterViewModel(master: self)
        
        // Initialize persistant store managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to load application delegate")
        }
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    
    //
    // Description:
    //   Lifecycle method called when the view is loaded.
    //
    // Outlets not yet established
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure user is signed in
        guard let user = UserModel.getSharedInstance() else {
            // TODO: TODO: Bail if no user model
            fatalError("Could not load user");
        }
        
        guard let splitVC = self.splitViewController as? SplitViewController else {
            fatalError("Unable to load split view controller")
        }

        self.splitVC = splitVC;
        
        // Add "+" button to navigation bar
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addBarButtonPressed(_:))
        )
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController
                = (controllers[controllers.count-1] as! UINavigationController).topViewController
                as? DetailViewController
        }
        
        // Set title
        self.title = user.display_name
        
        // Set table view data source to view model member variable
        self.tableView.dataSource = self.viewModel
    }

    
    //
    // Description:
    //   Application lifecycle method called when view is about to appear.
    //
    // Used for initialization that requires visual elements
    //
    override func viewWillAppear(_ animated: Bool) {
        
        // Get split view controller
        if let split = splitViewController {
            
            // Get detail view controller
            let controllers = split.viewControllers
            clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
            if let detailVC = controllers[controllers.count-1] as? UINavigationController {
                
                // Clear selected table view row if master view is not visible
                self.clearsSelectionOnViewWillAppear = split.isCollapsed
                
                // Get rid of large titles if master view is open
                if #available(iOS 11.0, *) {
                    detailVC.navigationBar.prefersLargeTitles = false
                }
            }
        }
        
        super.viewWillAppear(animated)
    }

    
    //
    // Description:
    //   Application lifecycle method called when view is about to disappear.
    //
    // Used to adapt other visual elements to new state
    //
    override func viewWillDisappear(_ animated: Bool) {
        
        // Get split view controller
        if let split = splitViewController {
            
            // Get detail view controller
            let controllers = split.viewControllers
            clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
            if let detailVC = controllers[controllers.count-1] as? UINavigationController {
                
                // Add large titles if master view is collapsed
                if #available(iOS 11.0, *) {
                    detailVC.navigationBar.prefersLargeTitles = true
                }
            }
        }
        
        super.viewWillDisappear(animated)
    }
    
    
    //
    // Description:
    //   Action when "+" bar button is pressed.
    //
    @objc func addBarButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToCreateNewInstall", sender: self)
    }

    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Segues
    // -----------------------------------------------------------------------------------------------------------------


    //
    // Description:
    //   Called before transition to next view controller.
    //
    // Initialize next view
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Indicate detail should not collapse
        if let splitVC = self.splitViewController as? SplitViewController {
            splitVC.collapseDetailViewController = false
        }
        
        // Set display mode button as back button
        let controller = (segue.destination as! UINavigationController).topViewController
        controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller?.navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Table View Delegate
    // -----------------------------------------------------------------------------------------------------------------
    
    
    //
    // Description:
    //   Called when user has selected a table view cell.
    //
    // Perform action appropriate for selected cell
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        case incompleteInstallItem.index:
            
            if indexPath.row == 0 {
                performSegue(withIdentifier: "segueToCreateNewInstall", sender: self)
            }
            
            break;
        case completeInstallItem.index:
            
            break;
        case profileActionsItem.index:
            
            if indexPath.row == 0 { // Manage Users
                
            } else if indexPath.row == 1 { // Sign Out
            
                self.displayActionSheet(
                    forView: tableView.cellForRow(at: indexPath),
                    withTitle: "Sign Out?",
                    message: "Are you sure you want to sign out?",
                    affirmLabel: "Sign Out"
                    ) { _ in
                    self.splitVC.unwindToSignIn()
                }
                
            }
            
            break;
        default:
            break;
        }
    }
}

