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

protocol UserInfo {
    var google_id: String { get set }
    var display_name: String { get set }
    var google_access_token: String? { get set }
    var admin_rights: Bool { get set }
    var dev: Bool { get set }
}

func getUserInfoFromNetworkObject(fromJsonObject json: [String:Any]) -> UserInfo? {
    
    guard let jsonData = json["data"] as? [String:Any] else {
        return nil
    }
    
    guard let arg_google_id = jsonData["google_id"] as? String,
        let arg_display_name = jsonData["display_name"] as? String,
        let arg_google_access_token = jsonData["google_access_token"] as? String?,
        let arg_admin_rights = jsonData["admin_rights"] as? Bool,
        let arg_dev = jsonData["dev"] as? Bool
        else {
            return nil
        }
    
    class UserInfoClass: UserInfo{
        var google_id: String
        var display_name: String
        var google_access_token: String?
        var admin_rights: Bool
        var dev: Bool
        init(
            google_id: String,
            display_name: String,
            google_access_token: String?,
            admin_rights: Bool,
            dev: Bool
        ) {
            self.google_id = google_id
            self.display_name = display_name
            self.google_access_token = google_access_token
            self.admin_rights = admin_rights
            self.dev = dev
        }
        
        
    }
    
    let result = UserInfoClass(
        google_id: arg_google_id,
        display_name: arg_display_name,
        google_access_token: arg_google_access_token,
        admin_rights: arg_admin_rights,
        dev: arg_dev
    )
    
    return result
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
    
    static func signIn(newUser user: GIDGoogleUser, callback: @escaping (Error?) -> Void) {
        
        guard let token = user.authentication.idToken else {
            print("Could not retrieve access token")
            return;
        }
        
        print("Token: \(token)")
        
        // Form request
        var request = URLRequest(url: URL(string: "http://standardwater.ddns.net/api/user/info")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Completion handler
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
         
            guard error == nil else {
                DispatchQueue.main.async {
                    callback( error! as NSError )
                }
                return
            }
            
            guard let data = data else {
                
                DispatchQueue.main.async {
                    callback(NSError(domain: "", code: 1, userInfo: nil))
                }
                return
            }
            
            var json: [String:Any]? = nil
            
            do {
                json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            }
            
            guard let jsonData = json else {
                DispatchQueue.main.async {
                    callback(NSError(domain: "", code: 1, userInfo: ["Message": "Could not extract json data"]))
                }
                return
            }
            
            guard let userInfo = getUserInfoFromNetworkObject(fromJsonObject: jsonData) else {
                DispatchQueue.main.async {
                    callback(NSError(domain: "", code: 1, userInfo: ["Message": "JSON data not user info"]))
                }
                return
            }
            
            manager.replaceUserEntity(withNewUser: userInfo)
            DispatchQueue.main.async {
                callback( nil )
            }
        }
        
        task.resume()
    }
    
    // Mark: - Object functionality
    
    fileprivate var userEntity: UserEntity
    
    var onlineStatus: Bool = false
    
    fileprivate init(withUserEntity user: UserEntity) {
        self.userEntity = user
    }
    
}
