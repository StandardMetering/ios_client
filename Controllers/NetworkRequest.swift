//
//  NetworkRequest.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/11/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation

class NetworkRequest {
    
    static func get(
        url: URL,
        attactchBearerToken bearerToken: String? = nil,
        completionCallback callback: @escaping (StandardMeteringError?, Any?) -> Void ) {
        
        // Form request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Completion handler
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check for network error
            guard error == nil else {
                DispatchQueue.main.async {
                    
                    callback(
                        StandardMeteringError(
                            code: .general,
                            message: "Networking Error"
                        ),
                        nil
                    )
                }
                return
            }
            
            // Ensure data was transmitted
            guard let data = data else {
                
                DispatchQueue.main.async {
                    callback(
                        StandardMeteringError(
                            code: .noDataTransmitted,
                            message: "No data transmitted"
                        ),
                        nil
                    )
                }
                return
            }
            
            var json: [String:Any]? = nil
            
            // Deserialize json data
            do {
                json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            }
            
            // Get data into dictionary
            guard let jsonData = json else {
                DispatchQueue.main.async {
                    callback(
                        StandardMeteringError(
                            code: .incorrectDataFormat,
                            message: "Data format not JSON"
                        ),
                        nil
                    )
                }
                return
            }
            
            // Get accepted field from response
            guard let accepted = jsonData["accepted"] as? Bool else {
                DispatchQueue.main.async {
                    callback(
                        StandardMeteringError(
                            code: StandardMeteringError.Code.unexpectedResponseStructure,
                            message: "Accepted filed not provided"
                        ),
                        nil
                    )
                }
                return;
            }
            
            
            // If response was not accepted
            if !accepted {
                
                // Get error
                guard let errorObject = jsonData["error"] as? [String:Any],
                    let errorObjectCode = errorObject["code"] as? Int,
                    let errorObjectMessage = errorObject["message"] as? String
                    else {
                        DispatchQueue.main.async {
                            callback(
                                StandardMeteringError(
                                    code: StandardMeteringError.Code.unexpectedErrorStructure,
                                    message: "Unknown Error Structure"
                                ),
                                nil
                            )
                        }
                        return;
                }
                
                // Pass error to callback
                DispatchQueue.main.async {
                    callback(
                        StandardMeteringError(
                            code: StandardMeteringError.Code(rawValue: errorObjectCode)!,
                            message: errorObjectMessage
                        ),
                        nil
                    )
                }
                return;
                
            
            }
            // If response was accepted
            else {
                
                // Get accepted field from response
                guard let dataType = jsonData["data_type"] as? String else {
                    DispatchQueue.main.async {
                        callback(
                            StandardMeteringError(
                                code: StandardMeteringError.Code.undeclatedDataType,
                                message: "Response data type not declared"
                            ),
                            nil
                        )
                    }
                    return;
                }
                
                guard let dataObject = jsonData["data"] as? [String:Any] else {
                    DispatchQueue.main.async {
                        callback(
                            StandardMeteringError(
                                code: StandardMeteringError.Code.unexpectedDataStructure,
                                message: "Response data not in json format"
                            ),
                            nil
                        )
                    }
                    return;
                }
                
                // If data type is user
                if dataType == "user" {
                    
                    if let userInfo = getUserInfoFromNetworkObject(fromJsonObject: dataObject) {
                        
                        DispatchQueue.main.async {
                            callback(
                                nil,
                                userInfo
                            )
                        }
                        return;
                        
                    } else {
                        DispatchQueue.main.async {
                            callback(
                                StandardMeteringError(
                                    code: StandardMeteringError.Code.unexpectedDataStructure,
                                    message: "Unexpected response data structure"
                                ),
                                nil
                            )
                        }
                        return;
                    }
                
                } else {
                    
                }
            }
        }
        
        task.resume()
    }
    
}

func getUserInfoFromNetworkObject(fromJsonObject jsonData: [String:Any]) -> UserInfo? {
    
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
