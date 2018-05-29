//
//  InstallModel.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation

class InstallModel: CustomStringConvertible {
    
    var complete: Bool
    var installNum: Int?
    
    init(isComplete: Bool, installNum: Int? = nil) {
        self.complete = isComplete
        self.installNum = installNum
    }
    
    public var description: String {
        return "\(self.complete ? "Complete install with num \(self.installNum ?? -1)" : "Incomplete install")"
    }
}
