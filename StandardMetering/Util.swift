//
//  Util.swift
//  StandardMetering
//
//  Created by Grant Broadwater on 6/25/18.
//  Copyright © 2018 StandardMetering. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func displayActionSheet(
        forView view: UIView? = nil,
        withTitle title: String,
        message: String,
        cancelLabel: String? = nil,
        cancelCallback: ((_:UIAlertAction) -> Void)? = nil,
        affirmLabel: String,
        affirmCallback: ((_:UIAlertAction) -> Void)? = nil
        ) {
        
        let optionMenu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let affirmAction = UIAlertAction(title: affirmLabel, style: .default, handler: affirmCallback);
        optionMenu.addAction(affirmAction)
        
        if let cancelLabel = cancelLabel {
            let cancelAction = UIAlertAction(title: cancelLabel, style: .cancel, handler: cancelCallback)
            optionMenu.addAction(cancelAction)
        }
        
        if let view = view {
            optionMenu.popoverPresentationController?.sourceView = view
            optionMenu.popoverPresentationController?.sourceRect = view.bounds
        } else {
            optionMenu.popoverPresentationController?.sourceView = self.view
            optionMenu.popoverPresentationController?.sourceRect = self.view.bounds
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
