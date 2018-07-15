//
//  InstallItemDetailCell.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 7/7/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import UIKit

class InstallItemDetailCell: UITableViewCell {

    @IBOutlet weak var lbl_itemIdentifier: UILabel!
    @IBOutlet weak var lbl_itemDetail: UILabel!
    
    var itemIdentifier: String? {
        didSet {
            if let text = self.itemIdentifier {
                self.lbl_itemIdentifier.text = text
            } else {
                self.lbl_itemIdentifier.text = "Not set"
            }
        }
    }
    
    var itemDetail: String? {
        didSet {
            if let text = self.itemDetail {
                self.lbl_itemDetail.text = text
            } else {
                self.lbl_itemDetail.text = "Not set"
            }
        }
    }
}
