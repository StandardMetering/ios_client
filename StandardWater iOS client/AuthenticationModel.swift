//
//  AuthenticationModel.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/16/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation

let AUTH_URL = URL(string: "http://standardwater.ddns.net/authenticate")!

class AuthenticationModel {
    
    static func authenticate(token: String, completionHandler: @escaping (Bool) -> Void) {
        
        var request = URLRequest(url: AUTH_URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            guard let _ = data else {
                print("Data is empty")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            // Check HTTP Response Status Code
            if let res = response as? HTTPURLResponse {
                
                // Check for valid response
                if res.statusCode != 200 {
                    print( "HTTP Response \(res.statusCode)" )
                    DispatchQueue.main.async {
                        completionHandler( false );
                    }
                    return
                }
            }
            
            var d = [String:AnyObject]()
            do {
                d = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject])!
            } catch {
                print( error.localizedDescription )
                DispatchQueue.main.async {
                    completionHandler( false );
                }
            }
            
            let isValidGoogleUser = d["isValidGoogleUser"] as! Bool?
            let isValidStandardWaterUser = d["isValidStandardWaterUser"] as! Bool?
            
            guard let _ = isValidGoogleUser else {
                print("Could not interprest response")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            
            guard isValidGoogleUser! == true else {
                print("Response indicates google user is not valid")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            guard let _ = isValidStandardWaterUser else {
                print("Could not interprest response")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            
            guard isValidStandardWaterUser! == true else {
                print("Response indicates user is not valid")
                DispatchQueue.main.async {
                    completionHandler( false );
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler( true );
            }
        }
        
        task.resume()
    }
    
    static func handleAuthResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        guard error == nil else {
            print(error!)
            return
        }
        guard let _ = data else {
            print("Data is empty")
            return
        }
        
        // Check HTTP Response Status Code
        if let res = response as? HTTPURLResponse {
            
            // Check for valid response
            if res.statusCode != 200 {
                print( "HTTP Response \(res.statusCode)" )
                return
            }
        }
        
        var d = [String:AnyObject]()
        do {
            d = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject])!
        } catch {
            print( error.localizedDescription )
        }
        
        let isValidGoogleUser = d["isValidGoogleUser"] as! Bool?
        let isValidStandardWaterUser = d["isValidStandardWaterUser"] as! Bool?
        
        guard let _ = isValidGoogleUser else {
            print("Could not interprest response")
            return
        }
        
        
        guard isValidGoogleUser! == true else {
            print("Response indicates google user is not valid")
            return
        }
        
        guard let _ = isValidStandardWaterUser else {
            print("Could not interprest response")
            return
        }
        
        
        guard isValidStandardWaterUser! == true else {
            print("Response indicates user is not valid")
            return
        }
        
    }
}
