//
//  UserModel.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import GoogleSignIn

extension NSNotification.Name {
    public static let UserModelDidUpdate = NSNotification.Name("UserModelDidUpdate");
}

fileprivate class UserModelManager: NSObject, NSFetchedResultsControllerDelegate {

    fileprivate var managedObjectContext: NSManagedObjectContext
    fileprivate var userModel: UserModel? = nil {
        didSet {
            NotificationCenter.default.post(
                name: Notification.Name.UserModelDidUpdate,
                object: self
            );
        }
    }
    
    fileprivate override init() {
        
        // Reference application delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to reference application delegate")
        }
        
        // Get persistent storage context
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        super.init()
        
        self.getStoredUser()
    }
    
    func getStoredUser() {
        
        
        // Make fetch request
        let managedContext = self.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        
        // Perform request
        do {
            let users = try managedContext.fetch(fetchRequest) as! [UserEntity]
            
            if let user = users.first {
                
                if users.count > 1 {
                    print("WARNING: multiple users stored. Using first user to sign in")
                }
                
                self.userModel = UserModel(withUserEntity: user)
                self.userModel?.onlineStatus = false
                
            } else {
                print("No users saved")
            }
            
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func replaceUserEntity(withNewUser user: GIDGoogleUser) {
        
        let context = self.managedObjectContext
        var deleteRequest: NSBatchDeleteRequest? = nil
        
        // If current user
        if let _ = self.userModel {
            
            // Delete current user
            deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "UserEntity"))
        }
        
        // Create new user
        let newUser = UserEntity(context: context)
        
        // Initialize
        newUser.google_id = user.userID!
        newUser.display_name = user.profile.name
        newUser.google_access_token = user.authentication.accessToken!
        newUser.admin_rights = true
        newUser.dev = true
        
        do {
            
            // Try to delete old user
            if let delReq = deleteRequest {
                try context.execute(delReq)
            }
            
            // Try to save new user
            try context.save()
            self.getStoredUser()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
}

class UserModel: CustomStringConvertible {
    
    var description: String {
        return "User \"\(self.userEntity.display_name!)\"{\n" +
            "\tgoogle_id: \(self.userEntity.google_id!)" +
            "\tadmin_rights: \(self.userEntity.admin_rights)" +
            "\tdev: \(self.userEntity.dev)" +
        "}"
    }
    
    var google_id: String {
        return self.userEntity.google_id ?? "nil"
    }
    
    var display_name: String {
        return self.userEntity.display_name ?? "nil"
    }
    
    var google_access_token: String {
        return self.userEntity.google_access_token ?? "nil"
    }
    
    var admin_right: Bool {
        return self.userEntity.admin_rights
    }
    
    var dev: Bool {
        return self.userEntity.dev
    }
    
    // MARK: - Static functionality
    fileprivate static var manager: UserModelManager!
    
    static func initModule() {
        self.manager = UserModelManager()
    }
    
    static func getSharedInstance() -> UserModel? {
        return manager.userModel
    }
    
    static func signIn(newUser user: GIDGoogleUser) {
        manager.replaceUserEntity(withNewUser: user)
    }
    
    // Mark: - Object functionality
    
    fileprivate var userEntity: UserEntity
    
    var onlineStatus: Bool = false
    
    fileprivate init(withUserEntity user: UserEntity) {
        self.userEntity = user
    }
    
}
