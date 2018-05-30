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
}

class InstallModel: CustomStringConvertible {
    
    var installNum: Int?
    
    public var description: String {
        return ( (self.installNum == nil) ? "Nil Install" : "Install #\(self.installNum!)")
    }
    
    init(installNum: Int? = nil) {
        self.installNum = installNum
    }
    
    static func createNewInstall(user: UserModel, installNum num: Int, address: InstallAddress) {
        
        // Form request
        var request = URLRequest(url: URL(string: "http://standardwater.ddns.net/installs/create")!)
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
            
            print("response")
            
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
