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

//
// Description:
//   Manages the stored user object in the persistent store
//
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
    
    //
    // Description:
    //   Initialize module.
    //
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
    
    
    //
    // Description:
    //   Gets a user object from persistent context, if one exists.
    //
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
    
    
    //
    // Description:
    //   Replaces the existing saved user with a new one.
    //
    func replaceUserEntity(withNewUser user: UserInfo) {
        
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
        newUser.google_id = user.google_id
        newUser.display_name = user.display_name
        newUser.google_access_token = user.google_access_token
        newUser.admin_rights = user.admin_rights
        newUser.dev = user.dev
        
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

//
// Description:
//   Used as an interface to indicate an object contains all fields relevent to a user
//
protocol UserInfo {
    var google_id: String { get set }
    var display_name: String { get set }
    var google_access_token: String? { get set }
    var admin_rights: Bool { get set }
    var dev: Bool { get set }
}


//
// Description:
//   Public interface for managing the signed in user
//
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
    
    // -----------------------------------------------------------------------------------------------------------------
    // MARK: - Static Functionality
    // -----------------------------------------------------------------------------------------------------------------
    
    fileprivate static var manager: UserModelManager!
    
    //
    // Description:
    //   Initialize module.
    //
    static func initModule() {
        self.manager = UserModelManager()
    }
    
    
    //
    // Description:
    //   Get the user instance common accross the whole app
    //
    static func getSharedInstance() -> UserModel? {
        return manager.userModel
    }
    
    
    //
    // Description:
    //   authenticate a google user with back end
    //
    static func signIn(newUser user: GIDGoogleUser, callback: @escaping (StandardMeteringError?, Any?) -> Void) {
        
        guard let token = user.authentication.idToken else {
            print("Could not retrieve access token")
            return;
        }
        
        print("Token: \(token)")
        
        NetworkRequest.get(
            url: URL(string: "http://standardwater.ddns.net/api/user/info")!,
            attactchBearerToken: token ) { error, data in
            
                if let error = error {
                    callback( error, nil )
                    return
                }
                
                let userInfo = data as! UserInfo;
                manager.replaceUserEntity(withNewUser: userInfo)
                manager.userModel!.onlineStatus = true
                
                callback( nil, userInfo )
        }
    }
    
    // Mark: - Object functionality
    
    fileprivate var userEntity: UserEntity
    
    var onlineStatus: Bool = false
    
    fileprivate init(withUserEntity user: UserEntity) {
        self.userEntity = user
    }
    
}
