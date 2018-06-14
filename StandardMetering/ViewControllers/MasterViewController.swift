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

    var viewModel: MasterViewModel! = nil
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        self.viewModel = MasterViewModel(master: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.viewModel = MasterViewModel(master: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = UserModel.getSharedInstance() else {
            // TODO: Perform segue
            fatalError("Could not load user");
        }
        
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.title = user.display_name
        
        // Table View
        self.tableView.dataSource = self.viewModel
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
            if let detailVC = controllers[controllers.count-1] as? UINavigationController {
                
                clearsSelectionOnViewWillAppear = split.isCollapsed
                
                if #available(iOS 11.0, *) {
                    detailVC.navigationBar.prefersLargeTitles = false
                }
            }
        }
        
        super.viewWillAppear(animated)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
            if let detailVC = controllers[controllers.count-1] as? UINavigationController {
                
                if #available(iOS 11.0, *) {
                    detailVC.navigationBar.prefersLargeTitles = true
                }
            }
        }
        
        super.viewWillDisappear(animated)
    }
    
    
    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Event(context: context)
             
        // If appropriate, configure the new managed object.
        newEvent.timestamp = Date()

        // Save the context.
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
    var fetchedResultsController: NSFetchedResultsController<Event> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.reloadData()
     }

}

