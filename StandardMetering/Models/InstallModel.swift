//
//  InstallModel.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/25/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSNotification.Name {
    public static let installModelDidUpdate = NSNotification.Name("InstallModelDidUpdate");
}

class InstallModel {
    
    private static let managedContext: NSManagedObjectContext
        = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //
    // Description:
    //   Gets all saved install entities.
    //
    static func getAllSavedInstalls() -> [InstallEntity] {
        
        var installs = [InstallEntity]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InstallEntity")
        
        do {
            installs = try managedContext.fetch(fetchRequest) as! [InstallEntity]
        } catch {
            print("Error in getAllSavedInstalls")
        }
        
        return installs
    }
    
    
    //
    // Description:
    //   Creates a new install object in the persistent store.
    //
    static func createNewInstall(
        withNum installNum: String,
        address: Address
        ) {
        
        let description = NSEntityDescription.entity(forEntityName: "InstallEntity", in: managedContext)
        let newInstall = InstallEntity(entity: description!, insertInto: managedContext)
        
        newInstall.install_num = installNum
        newInstall.address_street = address.street
        newInstall.address_city = address.city
        newInstall.address_state = address.state
        newInstall.address_zip = address.zip
        
        newInstall.able_to_complete = false
        newInstall.sync_status = false
        
        managedContext.insert(newInstall)
        
        do {
            try managedContext.save()
        } catch {
            print("ERRRRR!")
            return;
        }
        
        NotificationCenter.default.post(
            name: .installModelDidUpdate,
            object: nil
        );
    }
    
}
