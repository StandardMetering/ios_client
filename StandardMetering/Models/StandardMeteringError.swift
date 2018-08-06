//
//  File.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/11/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation

class StandardMeteringError {
    
    enum Code: Int {
        // No Error
        case noError = -1
        
        // General Errors
        case general = 0
        case noDataTransmitted = 1
        case incorrectDataFormat = 2
        case unexpectedResponseStructure = 3
        case unexpectedErrorStructure = 4
        case undeclatedDataType = 5
        case unexpectedDataStructure = 6
        
        // Client Errors
        case clientGeneral = 600
        
        case tokenRequired = 601
        case tokenMalformed = 602
        case tokenDoesNotMatchAnyUser = 603
        case tokenExpired = 604
        case tokenGeneral = 605
        
        case dataMalformed = 610
    }
    
    // Local values
    let code: StandardMeteringError.Code
    let message: String
    let error_data: Any?
    
    init( code: StandardMeteringError.Code, message: String, error_data: Any? = nil) {
        self.code = code
        self.message = message
        self.error_data = error_data
    }
}
