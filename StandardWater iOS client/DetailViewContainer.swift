//
//  DetailViewContainer.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/23/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import UIKit

enum DetailDisplay {
    case beginNewInstall
    case completeInstall
}

class DetailViewContainer: UIViewController {
    
    var didPresent = false;
    
    var detailToDisplay: DetailDisplay?
    var installModel: InstallModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didPresent {
            didPresent = true
        } else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if let displayMode = self.detailToDisplay {
            switch displayMode {
            case .beginNewInstall:
                performSegue(withIdentifier: "segueToBeginNewInstall", sender: self)
            case .completeInstall:
                performSegue(withIdentifier: "segueToCompleteInstall", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch( segue.identifier ) {
        case "segueToBeginNewInstall":
            if let dest = segue.destination as? BeginNewInstallViewController {
                dest.installModel = self.installModel
            }
            break;
        case "segueToCompleteInstall":
            if let dest = segue.destination as? ExistingInstallViewController {
                dest.installModel = self.installModel
            }
            break;
        default:
            break;
        }
    }
}
