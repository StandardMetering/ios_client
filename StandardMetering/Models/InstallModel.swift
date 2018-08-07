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
        
        if !self.saveContext() {
            print("Could not create new install")
            return;
        }
    }
    
    
    //
    // Description:
    //   Called when an install has been manipulated and a save is required.
    //
    static func saveContext() -> Bool {
        do {
            try managedContext.save()
            NotificationCenter.default.post(
                name: .installModelDidUpdate,
                object: nil
            );
            return true;
        } catch {
            print("ERRRRR!")
            return false;
        }
    }
    
    static func delete(_ install: InstallEntity) {
        managedContext.delete(install);
        if(!self.saveContext()) {
            print("Could not save context to delete install \(install.install_num ?? "NULL")")
        }
    }
    
    /**
        Syncs an install to the standard metering server
     */
    static func sync(install: InstallEntity) {
        
        guard let user = UserModel.getSharedInstance() else {
            fatalError("Could not get user")
        }
        
        var jsonData = try? install.asDictionary()
        jsonData!["address"] = install.getAddressAsDictionary()
        guard let jsonInstall = jsonData else {
            fatalError("Could not convert install to json")
        }
        
        NetworkRequest.post(
            url: URL(string: "http://standardmetering.ddns.net/api/install")!,
            withParameters: jsonInstall,
            attatchBearerToken: user.google_access_token
        ) { error, data in
            
            guard error == nil else {
                print("Could not post install to server")
                if let err = error {
                    print(err.message)
                }
                return
            }
            
            install.sync_status = true;
            if( !InstallModel.saveContext() ) {
                print("Could not save updated sync status on install '\(install.install_num ?? "NULL")'")
            }
            
        }
    }
    
   
    static let installFieldKeys = [
        "install_num",
        "address_street",
        "address_city",
        "address_state",
        "address_zip",
        
        "able_to_complete",
        "pre_image",
        "pre_valve_pos",
        "pre_notes",
        
        "complete"
    ]
    
    static let installFieldDescriptions = [
        "Install Number",
        "Address Street",
        "Address City",
        "Address State",
        "Address Zip Code",
        
        "Able to Complete",
        "Pre-install Image",
        "Pre-install Valve Postion",
        "Pre-install notes",
        
        "Complete"
    ]
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}

extension InstallEntity: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case install_num
        case address_street
        case address_city
        case address_state
        case address_zip
        
        case able_to_complete
        case pre_image
        case pre_valve_pos
        case pre_notes
        
        case complete
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(install_num, forKey: .install_num)
        try container.encode(address_street, forKey: .address_street)
        try container.encode(address_city, forKey: .address_city)
        try container.encode(address_state, forKey: .address_state)
        try container.encode(address_zip, forKey: .address_zip)
        
        try container.encode(able_to_complete, forKey: .able_to_complete)
        try container.encode(pre_image, forKey: .pre_image)
        try container.encode(pre_valve_pos, forKey: .pre_valve_pos)
        try container.encode(pre_notes, forKey: .pre_notes)
        
        try container.encode(complete, forKey: .complete)
    }
    
    public func getAddressAsDictionary() -> [String:String] {
        let addressDic: [String:String] = [
            "street": self.address_street!,
            "city": self.address_city!,
            "state": self.address_state!,
            "zip": self.address_zip!
        ]
        
        return addressDic
    }
}
