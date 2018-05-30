//
//  InstallModel.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation

class InstallModel: CustomStringConvertible {
    
    var installNum: Int?
    
    init(installNum: Int? = nil) {
        self.installNum = installNum
    }
    
    public var description: String {
        return ( (self.installNum == nil) ? "Nil Install" : "Install #\(self.installNum)")
    }
}
