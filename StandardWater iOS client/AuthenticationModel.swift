//
//  AuthenticationModel.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/16/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation

// Constants
let AUTH_URL = URL(string: "http://standardwater.ddns.net/authenticate")!

class AuthenticationModel {
    
    // Authenticate a users access token
    static func authenticate(token: String, completionHandler: @escaping (Bool) -> Void) {
        
        // Form request
        var request = URLRequest(url: AUTH_URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Completion handler
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check for error
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Check data is not empty
            guard let _ = data else {
                print("Data is empty")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Check HTTP Response Status Code
            if let res = response as? HTTPURLResponse {
                
                // Check for accepted response code
                if res.statusCode != 200 {
                    print( "HTTP Response \(res.statusCode)" )
                    DispatchQueue.main.async {
                        completionHandler( false );
                    }
                    return
                }
            }
            
            // Convert data from json
            var d = [String:AnyObject]()
            do {
                d = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject])!
            } catch {
                print( error.localizedDescription )
                DispatchQueue.main.async {
                    completionHandler( false );
                }
            }
            
            // Get two fields from response
            let isValidGoogleUser = d["isValidGoogleUser"] as! Bool?
            let isValidStandardWaterUser = d["isValidStandardWaterUser"] as! Bool?
            
            // Check field is present
            guard let _ = isValidGoogleUser else {
                print("Could not interprest response")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Check value is true
            guard isValidGoogleUser! == true else {
                print("Response indicates google user is not valid")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Check field is present
            guard let _ = isValidStandardWaterUser else {
                print("Could not interprest response")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Check value is true
            guard isValidStandardWaterUser! == true else {
                print("Response indicates user is not valid")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Report user as authenticated
            DispatchQueue.main.async {
                completionHandler( true );
            }
        }
        
        // Execute async task
        task.resume()
    }
}
