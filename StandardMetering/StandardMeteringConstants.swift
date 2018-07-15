//
//  StandardMeteringConstants.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/10/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation
import UIKit

let APPLICATION_TITLE = "Standard Metering"
let COPYRIGHT_STRING =  "© Standard Metering.\n" +
                        "This application and all its content is protected intelectual property of Standard Metering LLC."

extension UIColor {
    open static var forrestGreen = UIColor(red: 34.0/255, green: 139.0/255, blue: 34.0/255, alpha: 1.0)
}

let syncCompleteText = "Sync ✓"
let syncNeededText = "Sync !"

let usStates = [ "AK - Alaska",
                 "AL - Alabama",
                 "AR - Arkansas",
                 "AZ - Arizona",
                 "CA - California",
                 "CO - Colorado",
                 "CT - Connecticut",
                 "DC - District of Columbia",
                 "DE - Delaware",
                 "FL - Florida",
                 "GA - Georgia",
                 "GU - Guam",
                 "HI - Hawaii",
                 "IA - Iowa",
                 "ID - Idaho",
                 "IL - Illinois",
                 "IN - Indiana",
                 "KS - Kansas",
                 "KY - Kentucky",
                 "LA - Louisiana",
                 "MA - Massachusetts",
                 "MD - Maryland",
                 "ME - Maine",
                 "MI - Michigan",
                 "MN - Minnesota",
                 "MO - Missouri",
                 "MS - Mississippi",
                 "MT - Montana",
                 "NC - North Carolina",
                 "ND - North Dakota",
                 "NE - Nebraska",
                 "NH - New Hampshire",
                 "NJ - New Jersey",
                 "NM - New Mexico",
                 "NV - Nevada",
                 "NY - New York",
                 "OH - Ohio",
                 "OK - Oklahoma",
                 "OR - Oregon",
                 "PA - Pennsylvania",
                 "PR - Puerto Rico",
                 "RI - Rhode Island",
                 "SC - South Carolina",
                 "SD - South Dakota",
                 "TN - Tennessee",
                 "TX - Texas",
                 "UT - Utah",
                 "VA - Virginia",
                 "VI - Virgin Islands",
                 "VT - Vermont",
                 "WA - Washington",
                 "WI - Wisconsin",
                 "WV - West Virginia",
                 "WY - Wyoming"]

class StatesPickerViewDataSource: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //
    // Description:
    //   Return the number of columns in the picker view
    //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //
    // Description:
    //   Determines the number of rows in a column
    //
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usStates.count
    }
    
    
    //
    // Description:
    //   Gets the label text for a specific picker view row
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usStates[row]
    }
    
    //
    // Description:
    //   Called when a user has selected a specific picker view row
    //
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.tf_state.text = usStates[row].split(separator: "-")[1].trimmingCharacters(in: .whitespaces)
        print("Selected: \(usStates[row])")
    }
}
