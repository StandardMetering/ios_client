//
//  InstallModel.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation

class InstallAddress {
    var street: String? = nil
    var city: String? = nil
    var state: String? = nil
    var zip: String? = nil
    
    
    init() {
        street = nil
        city = nil
        state = nil
        zip = nil
    }
    
    init(street: String, city: String, state: String, zip: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
    }
}

struct InstallData {
    
    var installNum: Int
    var creatorGoogleId: String
    var address: InstallAddress
    
    init() {
        installNum = -1
        creatorGoogleId = ""
        address = InstallAddress();
    }
    
    init( _ instNum: Int, creatorGoogleId googleId: String, address: InstallAddress) {
        self.installNum = instNum
        self.creatorGoogleId = googleId
        self.address = address
    }
}

class InstallModel: CustomStringConvertible {
    
    var installData: InstallData?
    
    public var description: String {
        return ( (self.installData == nil) ? "Nil Install" : "Install #\(self.installData!.installNum)")
    }
    
    init(installNum: Int? = nil) {
        if let instNum = installNum {
            self.installData = InstallData()
            self.installData!.installNum = instNum
        }
    }
    
    init(data: InstallData) {
        self.installData = data
    }
    
    static func getAllInstallsByUser(user: UserModel, callback: @escaping (_: [InstallData]?) -> Void) {
        
        // Form request
        var request = URLRequest(url: URL(string: "http://standardwater.ddns.net/installs/")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Completion handler
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check for error
            guard error == nil else {
                print(error!)
                return
            }
            
            // Check data is not empty
            guard let _ = data else {
                print("Data is empty")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let responseJSON = responseJSON as? [[String: Any]] {
                
                var data = [InstallData]()
                var address = InstallAddress();
                
                for JSONinstall in responseJSON {
                    
                    address = InstallAddress(
                        street: ((JSONinstall["address"] as! [String:Any])["street"]! as! String),
                        city: ((JSONinstall["address"] as! [String:Any])["city"]! as! String),
                        state: ((JSONinstall["address"] as! [String:Any])["state"]! as! String),
                        zip: ((JSONinstall["address"] as! [String:Any])["zip"]! as! String)
                    )
                    
                    data.append(InstallData(
                        (JSONinstall["install_number"]! as! Int),
                        creatorGoogleId: (JSONinstall["user_google_id"]! as! String),
                        address: address
                    ))
                
                }
                
                DispatchQueue.main.async {
                    callback( data )
                    return
                }
                
            } else {
                DispatchQueue.main.async {
                    callback( nil )
                    return
                }
            }
            
        }
        
        task.resume()
    }
    
    static func createNewInstall(user: UserModel, installNum num: Int, address: InstallAddress) {
        
        // Form request
        var request = URLRequest(url: URL(string: "http://standardwater.ddns.net/installs/")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: Any] = [
            "installNumber": num,
            "address": [
                "street": address.street,
                "city": address.city,
                "state": address.state,
                "zip": address.zip
            ]
        ]
        let json = try? JSONSerialization.data(withJSONObject: data)
       
        request.httpBody = json
        
        // Completion handler
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check for error
            guard error == nil else {
                print(error!)
                return
            }
            
            // Check data is not empty
            guard let _ = data else {
                print("Data is empty")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            
        }
        
        task.resume()
    }
}
